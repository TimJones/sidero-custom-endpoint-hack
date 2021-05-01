ARG SIDERO_IMAGE

FROM gcc:10 AS build
ARG SIDERO_IP

RUN git clone git://git.ipxe.org/ipxe.git /opt/ipxe
WORKDIR /opt/ipxe/src
COPY talos.ipxe .
RUN sed -e "s/%SIDERO_IP%/${SIDERO_IP}/" -i talos.ipxe
RUN make bin-x86_64-efi/ipxe.efi BUNDLE=talos.ipxe
RUN make bin/undionly.kpxe BUNDLE=talos.ipxe

FROM ${SIDERO_IMAGE}
COPY --from=build /opt/ipxe/src/bin/undionly.kpxe /var/lib/sidero/tftp/talos.undionly.kpxe
COPY --from=build /opt/ipxe/src/bin-x86_64-efi/ipxe.efi /var/lib/sidero/tftp/talos.ipxe.efi
