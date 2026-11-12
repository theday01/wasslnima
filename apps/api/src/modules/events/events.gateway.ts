import {
  WebSocketGateway,
  WebSocketServer,
  SubscribeMessage,
  MessageBody,
  ConnectedSocket,
  OnGatewayConnection,
  OnGatewayDisconnect,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { Logger } from '@nestjs/common';

@WebSocketGateway({
  cors: { origin: '*' },
  namespace: '/',
})
export class EventsGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  private readonly logger = new Logger(EventsGateway.name);

  // In-memory active drivers location store (backed by Redis in production)
  private readonly activeDriversLocation = new Map<
    string,
    { lat: number; lng: number; heading: number; socketId: string }
  >();

  handleConnection(client: Socket) {
    this.logger.log(`Client connected to WebSocket: ${client.id}`);
  }

  handleDisconnect(client: Socket) {
    this.logger.log(`Client disconnected: ${client.id}`);
    // Clean up active driver if disconnected
    for (const [driverId, data] of this.activeDriversLocation.entries()) {
      if (data.socketId === client.id) {
        this.activeDriversLocation.delete(driverId);
        break;
      }
    }
  }

  /**
   * Driver broadcasts live location every 3-5 seconds
   */
  @SubscribeMessage('driver:update_location')
  handleLocationUpdate(
    @ConnectedSocket() client: Socket,
    @MessageBody()
    data: { driverId: string; lat: number; lng: number; heading?: number },
  ) {
    this.activeDriversLocation.set(data.driverId, {
      lat: data.lat,
      lng: data.lng,
      heading: data.heading || 0,
      socketId: client.id,
    });

    // Also join driver specific room
    client.join(`driver:${data.driverId}`);
    return { acknowledged: true };
  }

  /**
   * Broadcast new ride negotiation request to drivers in active room
   */
  broadcastRideRequest(cityId: string, requestData: any) {
    this.logger.log(
      `Broadcasting ride request ${requestData.id} to city room: ${cityId}`,
    );
    this.server.to(`city:${cityId}`).emit('ride:new_request_broadcast', requestData);
  }

  /**
   * Push driver bid offer directly to rider's private socket room
   */
  pushOfferToRider(riderId: string, offerData: any) {
    this.logger.log(`Pushing driver bid offer to rider: ${riderId}`);
    this.server.to(`rider:${riderId}`).emit('rider:new_offer_received', offerData);
  }

  /**
   * Notify driver that rider accepted their offer
   */
  notifyDriverOfferAccepted(driverId: string, rideData: any) {
    this.logger.log(`Notifying driver ${driverId} offer was accepted!`);
    this.server.to(`driver:${driverId}`).emit('driver:offer_accepted', rideData);
  }

  /**
   * Join specific user room (rider or driver)
   */
  @SubscribeMessage('user:join_room')
  handleJoinRoom(
    @ConnectedSocket() client: Socket,
    @MessageBody() data: { userId: string; role: 'RIDER' | 'DRIVER'; cityId?: string },
  ) {
    if (data.role === 'RIDER') {
      client.join(`rider:${data.userId}`);
    } else {
      client.join(`driver:${data.userId}`);
      if (data.cityId) {
        client.join(`city:${data.cityId}`);
      }
    }
    return { joined: true, room: `${data.role.toLowerCase()}:${data.userId}` };
  }
}

