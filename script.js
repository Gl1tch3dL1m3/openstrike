window.SetStatusChanged = function(status)
{
    document.getElementById("loadingtext").innerHTML = status;
}

window.SetFilesNeeded = function(needed)
{
    const e = document.getElementById("loadingbar");
    e.value = e.max - needed;
}

window.SetFilesTotal = function(total)
{
    document.getElementById("loadingbar").max = total;
}