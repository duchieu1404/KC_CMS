FROM node:16-alpine
# Create app directory
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
# Bundle app source
COPY . .
#RUN npm run build --nomaps
EXPOSE 3003

# Run the app
CMD [ "npm", "start" ]
