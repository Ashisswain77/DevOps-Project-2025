# Use Node.js base image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package.json and install deps
COPY package*.json ./
RUN npm install

# Copy app files
COPY . .

# Expose port (change if your app uses different one)
EXPOSE 3000

# Start the app
CMD ["npm", "start"]
