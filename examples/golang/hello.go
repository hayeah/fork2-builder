package main

import (
  "fmt"
  "time"
)

func main() {
  for i := 0; i <= 5; i++ {
    fmt.Printf("Hello World: %d\n",i)
    time.Sleep(800*time.Millisecond)
  }
  fmt.Println("done")
}
