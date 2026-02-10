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

window.DownloadingFile = function(file)
{
    document.getElementById("progress").style.width = current / max * 100 + "%";
    console.log(current);
}
