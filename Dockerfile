FROM node:22.18.0-alpine as builder

WORKDIR '/app'

COPY package.json .

RUN npm install

COPY . .

RUN ["npm", "run","build"]

RUN if [ -d "/app/dist" ]; then \
      cp -r /app/dist /tmp/site; \
    elif [ -d "/app/build" ]; then \
      cp -r /app/build /tmp/site; \
    else \
      echo "❌ Neither /app/dist nor /app/build exists. Did your build run?"; \
      exit 1; \
    fi

FROM nginx
COPY --from=builder /app/build /usr/share/nginx/html
