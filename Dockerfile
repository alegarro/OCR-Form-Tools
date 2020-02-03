# Stage 1
FROM node:10 AS build

# Create app directory
WORKDIR /usr/src/app

ENV PATH /usr/src/app/node_modules/.bin:$PATH

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./
RUN npm install

COPY . .

# Build the app for production
RUN npm run build

# Stage 2
# Use Nginx to serve files
FROM nginx:1.16.0-alpine
WORKDIR /usr/src/app

COPY --from=build /usr/src/app/run.sh .
COPY --from=build /usr/src/app/build /usr/share/nginx/html
EXPOSE 80
ENTRYPOINT [ "./run.sh" ]