FROM ubuntu AS build
RUN apt update
RUN apt install -y curl
RUN curl -O https://dl.google.com/go/go1.14.3.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.14.3.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin
RUN mkdir -p /src
WORKDIR /src
ADD . /src/
RUN go build -o ideal-happiness

FROM ubuntu
RUN mkdir -p /src
WORKDIR /src
COPY --from=build /src/static static
COPY --from=build /src/templates templates
COPY --from=build /src/ideal-happiness ideal-happiness
EXPOSE 8080
CMD ["./ideal-happiness"]
