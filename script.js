var max = 0;
var current = 0;

window.SetStatusChanged = function(status)
{
    document.getElementById("loadingtext").innerHTML = status;
}

window.SetFilesNeeded = function(needed)
{
    const e = document.getElementById("progress");
    e.value = (e.max - needed) / e.max * 100;
}

window.SetFilesTotal = function(total)
{
    document.getElementById("progress").max = total;
}