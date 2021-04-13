FROM ubuntu:20.04 as builder


RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install build-essential qt5-default make  -y
RUN mkdir -p /skyscraper
WORKDIR /skyscraper
COPY . /skyscraper

RUN rm -rf build/** \
    && mkdir -p build \
    && cd build \
    && qmake .. \
    && make -j$(nproc) \
    && make install

ENTRYPOINT ["/skyskraper/build/Skyscraper"]



FROM ubuntu:20.04 as skyscraper

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install qt5-default --no-install-recommends -y
COPY --from=builder  /skyscraper/build/Skyscraper /usr/local/bin/Skyscraper

ENTRYPOINT [ "/usr/local/bin/Skyscraper" ]


# How to build:
#
# source VERSION; docker build --target builder -t skyscraper:$VERSION-builder . 
# source VERSION; docker build --cache-from skyscraper:$VERSION-builder --target skyscraper -t skyscraper:$VERSION .  
#
# Or in one go without caching of the builder image:
# source VERSION; docker build --target skyscraper -t skyscraper:$VERSION .  

# Running:
# source VERSION; docker run --rm -it skyscraper:$VERSION --version
