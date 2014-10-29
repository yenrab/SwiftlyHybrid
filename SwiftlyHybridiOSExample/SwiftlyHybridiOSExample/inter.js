var count = 0

function sendCount(){
    var message = {"count":count}
    window.webkit.messageHandlers.interOp.postMessage(message)
}

function storeAndShow(updatedCount){
    document.querySelector("#resultDisplay").innerHTML = 'came back'
    count = updatedCount
    document.querySelector("#resultDisplay").innerHTML = count
}

function doLibCall(){
    //aSillyLibfunc exists in a directory. Some
    var aMessage = aSillyLibFunc()
    document.querySelector("#resultDisplay").innerHTML = aMessage
}