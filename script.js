var max = 0;
var current = 0;

window.SetStatusChanged = function(status)
{
    document.getElementById("loadingtext").innerHTML = status;
}
/*
window.SetFilesNeeded = function(needed)
{
    current = max - needed;
}
*/
window.DownloadingFile = function(file)
{
    //document.getElementById("progress").style.width = current / max * 100 + "%";
    document.getElementById("progress").style.width = "50%";
    current += 1;
}

window.SetFilesTotal = function(total)
{
    max = total;
    current = 0;
}
