FROM rust:latest AS builder

WORKDIR /usr/src/

RUN apt update
RUN apt install git python3-dev python3-pil python3-pil.imagetk -y

RUN wget https://server.duinocoin.com/fasthash/libducohash.tar.gz
RUN tar -xvf libducohash.tar.gz

WORKDIR /usr/src/libducohash
RUN cargo build --release
RUN mv target/release/libducohasher.so .

FROM python:3

RUN apt update
RUN apt install git python3-dev python3-pil python3-pil.imagetk -y

WORKDIR /usr/src/app

RUN git clone https://github.com/revoxhere/duino-coin ./

RUN python3 -m pip install -r requirements.txt

COPY --from=builder /usr/src/libducohash/libducohasher.so .

# Confirm it works:
RUN wget https://server.duinocoin.com/fasthash/PC_Miner.py

COPY ["Settings.cfg", "./Duino-Coin PC Miner 3.0/Settings.cfg"]

CMD python3 PC_Miner.py
