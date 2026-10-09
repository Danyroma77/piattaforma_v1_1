FROM node:22-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
# Normalizza CRLF Windows -> LF, altrimenti sh non trova lo script
RUN sed -i 's/\r$//' ./entrypoint.sh && chmod +x ./entrypoint.sh
EXPOSE 5173
CMD ["/bin/sh", "/app/entrypoint.sh"]
