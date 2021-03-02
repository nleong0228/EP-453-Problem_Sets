var num: Int
var width: Int

num = 48
width = 5

var count = 1

while count <= num  {
    print("*", terminator:"")
    if count % width == 0 {
        print(" ")
    }
    count = count + 1
}
