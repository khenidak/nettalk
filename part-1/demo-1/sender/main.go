package main

import (
	"fmt"
	"github.com/google/gopacket"
	"github.com/google/gopacket/layers"
	"net"
	"os"
)

func main() {
	dstIP := net.ParseIP("192.168.99.20") // vm1
	if dstIP == nil {
		fmt.Errorf("failed to parse IP")
		os.Exit(1)
	}

	dstPort := layers.UDPPort(10010)

	srcIP := net.ParseIP("192.168.99.10") // vm0
	srcPort := layers.UDPPort(10011)

	ipLayer := &layers.IPv4{
		SrcIP:    srcIP,
		DstIP:    dstIP,
		Protocol: layers.IPProtocolUDP,
	}

	transportLayer := &layers.UDP{
		SrcPort: srcPort,
		DstPort: dstPort,
	}

	if err := transportLayer.SetNetworkLayerForChecksum(ipLayer); err != nil {
		fmt.Errorf("failed to set network layer:%v\n", err)
		os.Exit(1)
	}
	rawBytes := []byte("Hello!")

	opts := gopacket.SerializeOptions{
		ComputeChecksums: true,
		FixLengths:       true,
	}

	buf := gopacket.NewSerializeBuffer()
	// note: gopacket takes care of adding the ethernet layer
	// gopacket.SerializeLayers is variadic and accepts n layer and works
	// its way downwards the stack
	if err := gopacket.SerializeLayers(buf, opts,
		transportLayer,
		gopacket.Payload(rawBytes),
	); err != nil {
		fmt.Printf("failed to serialize:%v\n", err)
		os.Exit(1)
	}

	c, err := net.ListenPacket("ip4:udp", "0.0.0.0")
	if err != nil {
		fmt.Printf("failed to listen packet:%v\n", err)
		os.Exit(1)
	}

	defer c.Close()
	fmt.Printf("writing..\n")
	if count, err := c.WriteTo(buf.Bytes(), &net.IPAddr{IP: dstIP}); err != nil {
		fmt.Printf("failed to send:%v", err)
		os.Exit(1)
	} else {
		fmt.Printf("wrote %v bytes\n", count)
	}
	fmt.Printf("Done!\n")
}
