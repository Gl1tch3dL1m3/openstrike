const max = 0;
const current = 0;

window.SetStatusChanged = function(status)
{
    document.getElementById("loadingtext").innerHTML = status;
}

window.SetFilesNeeded = function(needed)
{
    current = max - needed
    document.getElementById("loadingbar").style.width = current / max * 100;
}

window.SetFilesTotal = function(total)
{
    max = total
}
