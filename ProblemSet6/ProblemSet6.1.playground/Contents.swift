
class Weather {
    var low: Float
    var high: Float
    var prec: Float
    var wind: Float
    
    init(low: Float, high: Float, prec: Float, wind: Float) {
        self.low = low
        self.high = high
        self.prec = prec
        self.wind = wind
    }
}

var yesterday = Weather(low: 60, high: 80, prec: 20, wind: 10)

var today = Weather(low: 64, high: 76, prec: 10, wind: 11)


var lowdiff: Float
var highdiff: Float
var precdiff: Float
var winddiff: Float
    
    
lowdiff = (today.low)-(yesterday.low)
highdiff = (today.high)-(yesterday.high)
precdiff = (today.prec)-(yesterday.prec)
winddiff = (today.wind)-(yesterday.wind)

print("The weather difference between the two days is: ")
print("Low: \(lowdiff)°F")
print("High: \(highdiff)°F")
print("Precipitation: \(precdiff)%")
print("Wind Speed: \(winddiff)mph")
