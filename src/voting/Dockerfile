FROM node:10.11.0-alpine

# Install curl for debugging.
RUN apk --no-cache add curl

# Create app directory.
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies.
COPY ./src/voting/package.json /usr/src/app/
RUN npm install

# Bundle app source.
COPY ./src/voting/ /usr/src/app

EXPOSE 8080
CMD [ "npm", "start" ]
