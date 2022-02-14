FROM golang:alpine AS base
ENV GO111MODULE=on CGO_ENABLED=0
WORKDIR /opt
ADD ./src /opt
RUN apk update && apk add --no-cache upx 
RUN go mod tidy && go build -ldflags="-s -w" -o main && upx main

FROM gcr.io/distroless/static
COPY --from=base /opt/main main
EXPOSE 8080
CMD ["./main"]
