FROM node:20-alpine

WORKDIR /webapp

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000

CMD ["node", "index.js"]