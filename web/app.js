function alertMessage(text) {
    alert(text)
}

window.logger = (flutter_value) => {
    console.log({ js_context: this, flutter_value });
}

window.preventDefault();

document.addEventListener("keydown", function (e) {
    var charCode = e.charCode || e.keyCode || e.which;
    if (charCode == 27) {
        // alert("Escape is not suppressed for lightbox!");
        console.log("Escape oh yeah");
        return false;
    }
});