var sid;
var obj;
var idx;


const speech = [
    "Hello there!",
    "This is a WIP",
    "Hope you enjoy your stay!"
]


const icon = [
    "https://cdn.discordapp.com/attachments/862762318407139328/944975070835638272/Untitled_Artwork-3.png",
    "https://cdn.discordapp.com/attachments/862762318407139328/944975070915358821/Untitled_Artwork-4.png",
    "https://cdn.discordapp.com/attachments/862762318407139328/944975070827249684/Untitled_Artwork-2.png"
]


document.addEventListener('DOMContentLoaded',
    function() {
        sid = $("#sid").text;
        idx = 0;



    });




function next() {

    $("#textframe").html('<div id ="words">'.concat(speech[idx]).concat("</div>"));

    $("#backgroundImage").html('<img src="https://cdn.discordapp.com/attachments/862762318407139328/944977862111416350/Untitled_Artwork.png" alt="bkgd">');
    $("#iconframe").html('<img src="'.concat(icon[idx]).concat('"alt="icon">'));
    idx = idx + 1;


}