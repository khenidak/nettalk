package main

import (
	"fmt"
	"math/rand"
	"net"
	"os"
	"os/signal"
	"strings"
	"sync"
	"syscall"
	"time"
)

// simulate udp over faulty net with random waits
func funckySender(conn *net.UDPConn, to *net.UDPAddr, message string) {
	wg := sync.WaitGroup{}
	words := strings.Split(message, " ")
	for _, word := range words {
		wg.Add(1)
		go func(w string) {
			// random sleep
			ms := rand.Intn(100)
			time.Sleep(time.Duration(ms) * time.Millisecond)
			count, err := conn.WriteToUDP([]byte(w), to)
			if err != nil {
				fmt.Errorf("failed to send:%v", err)
				os.Exit(1)
			}
			if count != len(w) {
				fmt.Errorf("failed to send the entire word in one go\n")
				os.Exit(1)
			}
			wg.Done()
		}(word)
	}

	wg.Wait()
}

func main() {
	sigs := make(chan os.Signal, 1)
	signal.Notify(sigs, syscall.SIGINT, syscall.SIGTERM)

	addr, err := net.ResolveUDPAddr("udp", ":10001")
	if err != nil {
		fmt.Printf("failed to create the address requested:%v\n", err)
		os.Exit(1)
	}

	conn, err := net.ListenUDP("udp", addr)
	if err != nil {
		fmt.Printf("failed to listen:%v\n", err)
		os.Exit(1)
	}
	defer conn.Close()

	conn.SetReadDeadline(time.Now().Add(120 * time.Second))
	fmt.Printf("listening.. on %+v \n", addr)

	buf := make([]byte, 1024)
	for {
		select {
		case <-sigs:
			fmt.Printf("done!..\n")
			os.Exit(0)
			break
		default:
			count, rcvAddr, err := conn.ReadFromUDP(buf)
			if err != nil {
				if e, ok := err.(net.Error); !ok || !e.Timeout() {
					fmt.Printf("failed to recieve:%v\n", err)
					os.Exit(1)
				}
				continue
			}
			fmt.Printf("received %v from %v\n", string(buf[0:count]), addr)
			fmt.Printf("responding..\n")

			// respond with  greetings
			funckySender(conn, rcvAddr, "Hello, World!")
			fmt.Printf("responded...\n")
			fmt.Printf("******\n")
		}
	}
}
