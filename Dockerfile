# Multi-stage build for Azure Web App deployment

# Stage 1: Build
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package files
COPY package.json ./
COPY server/package.json ./server/
COPY client/package.json ./client/

# Install root dependencies
RUN npm install

# Install server dependencies
WORKDIR /app/server
RUN npm install

# Install client dependencies
WORKDIR /app/client
RUN npm install

# Copy source files
WORKDIR /app
COPY . .

# Build application
RUN npm run build

# Stage 2: Production
FROM node:20-alpine

WORKDIR /app

# Copy package files
COPY package.json ./
COPY server/package.json ./server/

# Install production dependencies only
RUN npm install --production
WORKDIR /app/server
RUN npm install --production

# Copy built files
COPY --from=builder /app/server/dist ./dist
COPY --from=builder /app/client/dist ./public

# Expose port
EXPOSE 3001

# Start server
CMD ["npm", "start"]


