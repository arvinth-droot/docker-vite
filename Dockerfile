# Stage 1: Build the application
FROM node:18-alpine AS build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the application
RUN npm run build

# Stage 2: Serve the built application
FROM nginx:alpine

# Copy built files from the build stage to the nginx directory
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 8080

# Change the default port to 9000
RUN sed -i -e 's/80/8080/g' /etc/nginx/conf.d/default.conf

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]