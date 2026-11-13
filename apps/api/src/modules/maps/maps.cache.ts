import { Injectable, Logger, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import Redis from 'ioredis';

@Injectable()
export class MapsCacheService implements OnModuleInit, OnModuleDestroy {
  private readonly logger = new Logger(MapsCacheService.name);
  private memoryCache = new Map<string, { val: any; expiresAt: number }>();
  private redisClient: Redis | null = null;
  private cleanupInterval: any;

  constructor(private readonly config: ConfigService) {
    // Memory cache cleanup timer every 10 minutes
    this.cleanupInterval = setInterval(() => this.cleanupMemoryCache(), 10 * 60 * 1000);
  }

  async onModuleInit() {
    const redisHost = this.config.get<string>('REDIS_HOST');
    const redisPort = this.config.get<number>('REDIS_PORT', 6379);
    const redisPassword = this.config.get<string>('REDIS_PASSWORD');

    if (redisHost) {
      try {
        this.redisClient = new Redis({
          host: redisHost,
          port: Number(redisPort),
          password: redisPassword || undefined,
          lazyConnect: true,
          maxRetriesPerRequest: 1,
          connectTimeout: 2000,
          retryStrategy: (times) => {
            if (times > 3) return null; // stop retrying, fallback to memory
            return Math.min(times * 1000, 3000);
          },
        });

        this.redisClient.on('error', (err) => {
          this.logger.warn(`Redis connection warning: ${err.message}. Using in-memory fallback.`);
        });

        await this.redisClient.connect();
        this.logger.log(`MapsCache connected to Redis at ${redisHost}:${redisPort}`);
      } catch (err: any) {
        this.logger.warn(`Could not connect to Redis: ${err.message}. Operating with in-memory cache.`);
        this.redisClient = null;
      }
    } else {
      this.logger.log('No REDIS_HOST configured; using local memory cache for maps.');
    }
  }

  async onModuleDestroy() {
    if (this.cleanupInterval) {
      clearInterval(this.cleanupInterval);
    }
    if (this.redisClient) {
      try {
        await this.redisClient.quit();
      } catch {
        // ignore
      }
    }
  }

  /**
   * Two-tier cache read: L1 Memory -> L2 Redis -> null
   */
  async get<T>(key: string): Promise<T | null> {
    // L1: Memory
    const entry = this.memoryCache.get(key);
    if (entry) {
      if (Date.now() < entry.expiresAt) {
        return entry.val as T;
      }
      this.memoryCache.delete(key);
    }

    // L2: Redis
    if (this.redisClient && this.redisClient.status === 'ready') {
      try {
        const raw = await this.redisClient.get(key);
        if (raw) {
          const parsed = JSON.parse(raw);
          // Backfill L1 memory for fast repeated hits
          this.memoryCache.set(key, {
            val: parsed,
            expiresAt: Date.now() + 60 * 1000, // keep 1 min in L1
          });
          return parsed as T;
        }
      } catch (err: any) {
        this.logger.warn(`Redis get error for key ${key}: ${err.message}`);
      }
    }

    return null;
  }

  /**
   * Two-tier cache write: L1 Memory + L2 Redis
   */
  async set(key: string, val: any, ttlSeconds: number): Promise<void> {
    // Set L1
    this.memoryCache.set(key, {
      val,
      expiresAt: Date.now() + ttlSeconds * 1000,
    });

    // Set L2
    if (this.redisClient && this.redisClient.status === 'ready') {
      try {
        await this.redisClient.set(key, JSON.stringify(val), 'EX', ttlSeconds);
      } catch (err: any) {
        this.logger.warn(`Redis set error for key ${key}: ${err.message}`);
      }
    }
  }

  generateSearchKey(query: string, proximityLat?: number, proximityLon?: number): string {
    const normalized = query.trim().toLowerCase().replace(/\s+/g, '_');
    const prox = proximityLat && proximityLon ? `_${proximityLat.toFixed(2)},${proximityLon.toFixed(2)}` : '';
    return `maps:search:${normalized}${prox}`;
  }

  generateReverseKey(lat: number, lon: number): string {
    return `maps:rev:${lat.toFixed(4)},${lon.toFixed(4)}`;
  }

  generateRouteKey(oLat: number, oLon: number, dLat: number, dLon: number): string {
    return `maps:route:${oLat.toFixed(4)},${oLon.toFixed(4)}->${dLat.toFixed(4)},${dLon.toFixed(4)}`;
  }

  private cleanupMemoryCache() {
    const now = Date.now();
    for (const [k, v] of this.memoryCache.entries()) {
      if (now >= v.expiresAt) {
        this.memoryCache.delete(k);
      }
    }
  }
}
