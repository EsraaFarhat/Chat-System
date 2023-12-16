# Chat System API
This repository contains the implementation of a chat system API using Ruby on Rails (v7.0.8). The API provides endpoints for creating, updating, and reading applications, chats, and messages. It also includes a search endpoint for messages using Elasticsearch. The system uses MySQL as the main datastore and leverages Redis for Sidekiq background jobs and RedLock for distributed locking.

## Overview
### 1. CRUD operations for applications
*  The client can perform GET, POST, PUT, and DELETE operations on applications.
### 2. CRUD operations for chats
*  The client can perform GET, POST, and DELETE operations on chats for each application.
### 3. CRUD operations for messages
*  The client can perform GET, POST, PUT, and DELETE operations on messages for each chat.
*  The client can search by part of the message body.

## Setup Instructions
### Prerequisites
*  Docker and Docker Compose installed on your machine.

### Prerequisites
1. Clone the repository:
```
git clone https://github.com/EsraaFarhat/Chat-System.git
cd Chat-System
```
2. Build and run the containers:
```
docker-compose up
```
3. Access the API at http://localhost:3000.

## Additional Notes
* The system uses Elasticsearch for efficient message searching.
* MySQL tables are optimized with appropriate indices.
* Sidekiq is integrated for background job processing.
* Redis is used for Sidekiq and can be extended for other caching needs.
* RedLock is used for distributed locking to handle race conditions.
* The system is containerized using Docker Compose.
