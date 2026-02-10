var max = 0;

window.SetStatusChanged = function(status)
{
    document.getElementById("loadingtext").innerHTML = status;
}

window.SetFilesNeeded = function(needed)
{
    if (max <= 0 || needed > max) max = needed;

    var downloaded = max - needed;
    var percentage = (downloaded / max) * 100;

    if (percentage < 0) percentage = 0;
    if (percentage > 100) percentage = 100;

    document.getElementById("progress").style.width = percentage + "%";
};

window.SetFilesTotal = function(total)
{
    max = total;
}
