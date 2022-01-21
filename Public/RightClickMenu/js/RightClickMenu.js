document.onclick = hideMenu;
document.oncontextmenu = rightClick;

function save(filename, data) {
  const blob = new Blob([data], {type: 'text/csv'});
  if(window.navigator.msSaveOrOpenBlob) {
      window.navigator.msSaveBlob(blob, filename);
  } else {
      const elem = window.document.createElement('a');
      elem.href = window.URL.createObjectURL(blob);
      elem.download = filename;        
      document.body.appendChild(elem);
      elem.click();        
      document.body.removeChild(elem);
  }
}

// Wait for the page to load first
window.onload = function() {
  var a = document.getElementById("save-button");
  a.onclick = function() {

    let documentString = new XMLSerializer().serializeToString(document);
    let data = {savedDocument: documentString};

    fetch("save", {
      method: "POST",
      headers: {'Content-Type': 'application/json'}, 
      body: JSON.stringify(data)
    }).then(res => {
      return res.text();
    }).then(text => {
      save("editedFile.html", text);
    });

    //If you don't want the link to actually
    // redirect the browser to another page,
    // "google.com" in our example here, then
    // return false at the end of this block.
    // Note that this also prevents event bubbling,
    // which is probably what we want here, but won't
    // always be the case.
    return true;
  }
}

function hideMenu() {
  document.getElementsByClassName("context-menu")[0]
  .style.display = "none"
}

function rightClick(e) {
  e.preventDefault();
  
  if (document.getElementsByClassName("context-menu")[0]
      .style.display == "block")
    hideMenu();
  else{
    var menu = document.getElementsByClassName("context-menu")[0]
    
    menu.style.display = 'block';
    menu.style.left = e.pageX + "px";
    menu.style.top = e.pageY + "px";
  }
}
