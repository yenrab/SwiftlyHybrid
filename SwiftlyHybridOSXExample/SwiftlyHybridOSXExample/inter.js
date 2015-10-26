
/*
 *Reasigning the webkit messageHandlers.native to the native var
 *simplifies later code and allows the iOS and Android versions
 *of the code to be consistant.
 */
var native = window.webkit.messageHandlers.native

