package main

import (
	"fmt"
	"net"
	"os"
)

func main() {
	l, err := net.Listen("tcp", ":10020")
	if err != nil {
		fmt.Printf("error listen:%v\n", err)
		os.Exit(1)
	}
	defer l.Close()

	// adding signal and cancelling the loop below is left for the reader (hint, it is done in a previous demo)

	fmt.Printf("listening on :10020..\n")
	for {
		// c represent a connection. the 3 way handshake
		// if there is a connection in the Accept() queue
		// then a syn has been send by client
		c, err := l.Accept()
		// now 3-way is done

		if err != nil {
			fmt.Printf("error accept: %v\n", err)
			os.Exit(1)
		}
		// this part typically run async
		buf := make([]byte, 1024)
		count, err := c.Read(buf)
		if err != nil {
			fmt.Printf("Error read:%v\n", err)
		}
		fmt.Printf("received(%v): \n%v\n", count, string(buf))
		// respond
		fmt.Printf("responding..\n")
		c.Write([]byte("HTTP/1.1 200 OK\r\nfancy-pants-header: Hello, World!\r\n\r\n"))
		fmt.Printf("responded\n")
		c.Close()
	}
}
