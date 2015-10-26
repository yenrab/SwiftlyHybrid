//you can put your regular JavaScript code in this file or any other.

var clicks = 0
function sendCount(){
    
    var message = {"cmd":"increment","count":clicks,"callbackFunc":function(responseAsJSON){
        var response = JSON.parse(responseAsJSON)
        clicks = response['count']
        document.querySelector("#messages_from_java").innerText = "Count is "+clicks
    }.toString()}
    native.postMessage(message)
}