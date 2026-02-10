var max = 0;
var current = 0;

window.SetStatusChanged = function(status)
{
    document.getElementById("loadingtext").innerHTML = status;
}

window.SetFilesNeeded = function(needed)
{
    current = max - needed;
}

window.SetFilesTotal = function(total)
{
    max = total;
}

setInterval(1000, function()
{
    document.getElementById("progress").style.width = current / max * 100 + "%";
})
