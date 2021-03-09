
let numbers = [1, 3, 5, 7, 12]

var count = numbers.count

func average(number: [Int]) -> Float{
    var i = 0
    var sum = 0

    for number in 0..<count{
        sum = numbers[i] + sum
        
        i += 1
    }
    

    return Float(sum)/Float(count)
}

print("The average of \(numbers) is \(average(number: numbers))")
