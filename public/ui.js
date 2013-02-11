var is_login, username, is_admin, userid, user_list_el, main_post_el, is_main_post_toggle, current_filter;
var edit_lock;
is_login = false;
username = "";
userid = -1;
is_admin = false;
current_filter = null;
edit_lock = false;
function load() {
    user_list_el = $("div#user_list");
    main_post_el = $("table#pmain");
    is_main_post_toggle = true;
    user_list_el.detach();
    $.get('/db_check.json', function (json, code) {
        console.log('db_check');
        console.log(json);
        if (json != true) {
            document.body.innerHTML = "<h1>Data Integrity check Failed! Trying to reset database......</h1><br /><h2>Please wait a few seconds.</h2>";
            location.href = "/db_init";
        }
    });
    $.get("/users/api_is_login.json",function (json,code) {
        console.log("api_is_login");
        console.log(json);
        if (json != null) {
            $("th#nav1")[0].innerHTML = "<a href='/users/" + json.id + "/edit' target='_blank'>" + json.name + "</a>, welcome back! <a href='/users/login?user[name]=logout'>logout</a>"
            username = json.name;
            userid = json.id;
            is_login = true;
            is_admin = json.admin;
            $("th#Post_th")[0].innerHTML = 'Posts&nbsp;&nbsp;[<a href="/posts/new" target="_self"><em>CREATE</em></a>]'
        } else {
            var str;
            str = "<form action='/users/login' method='POST'>name:<input type='text' name='user[name]' size=6/>password:<input type='password' name='user[password]' size=6/><input type='submit' value='login'>";
            str += "or <a href='/users/new' target='_blank'>Register!</a></form>";
            $("th#nav1")[0].innerHTML += str;
            $("th#Post_th")[0].innerHTML = "Posts"
            is_login = false;
        }
        load_plist_by_filter("");                   //admin and user see different list, so list should be loaded after call back
        $("input#search")[0].disabled = false;  //same, clicking search will enforce the list to be shown, disable the button before user id is retrieved
    });
    $.get("/users/api_is_admin.json", function (json,code){
        var l;
        console.log("api_is_admin");
        console.log(json);
        if (json) {
            $("th#nav2")[0].innerHTML = "Manage: <a href='/users' target='_blank'>Users</a>&nbsp;<a href='/categories' target='_blank'>Categories</a>";
            is_admin = true;
        } else {
            $("th#nav2")[0].innerHTML = "<a href='#' id='list_user_link'></a>";
            l = $("a#list_user_link")[0];
            l.innerHTML = "List users";
            l.onclick =toggle_container;
            $.get('/users/api_list.json', function (json,code) {
                var list, i;
                console.log("(users/)api_list");
                console.log(json);
                list = "";
                user_list_el[0].innerHTML = "";
                for (i = 0; i < json.length; i++) {
                    list += json[i].name;
                    if (json[i].id == userid) {
                        list += "&nbsp;<b>(you)</b>";
                    }
                    list += "</br>";
                }
                user_list_el[0].innerHTML = list;
            });
        }
    });
    $.get("/categories/api_list.json", function (json, code) {
        var selector, i, op;
        console.log("(categories/)api_list");
        console.log(json);
        selector = $("select#category")[0];
        selector.appendChild($("<option value='ALL'>ALL</option>")[0]);
        for (i = 0; i < json.length; i++) {
            op = document.createElement("option");
            op.value = json[i].id;
            op.innerHTML = json[i].n;
            selector.appendChild(op);
        }
    });
    $("input#search")[0].onclick = function () {
        var params;
        current_filter = "";
        if ( (params = $("input#keyword")[0].value) != "") {
            current_filter += (current_filter == "") ? "keyword=" + params : "&keyword=" + params;
        }
        if ( (params = $("input#user")[0].value) != "") {
            current_filter += (current_filter == "") ? "user=" + params : "&user=" + params;
        }
        if ( (params = $("select#category")[0].value) != "ALL") {
            current_filter += (current_filter == "") ? "category=" + params : "&category=" + params;
        }
        if (current_filter == "") {
            current_filter = null;
        }
        load_plist_by_filter(current_filter);
    };
}
$(document).ready(load);
function load_plist_by_filter(filter) {
    if (filter == null) {
        filter ="";
    }
    $.get("/posts/api_list.json" + ((filter == "") ? "" : ("?" + filter)), function (json,code){
        var tb,np,el, i,trs;
        console.log("(posts/)api_list");
        console.log(json);
        tb = $("table#plists").find("tbody")[0];
        trs = $(tb).find("tr");
        for (i = 1; i < trs.length; i++) {
            trs[i].remove();
        }
        for (i = 0; i < json.length; i++) {
            np = document.createElement("tr");
            el = document.createElement("td");
            el.innerHTML = "&lt;" + json[i].category.n + "&gt;&nbsp;&nbsp;<a href='javascript:show(" + json[i].id + ")'>" + json[i].t + "</a>";
            np.appendChild(el);
            el = document.createElement("td");
            el.innerHTML = json[i].u.n;
            np.appendChild(el);
            el = document.createElement("td");
            el.innerHTML = json[i].r;
            np.appendChild(el);
            el = document.createElement("td");
            el.innerHTML = json[i].v;
            np.appendChild(el);
            tb.appendChild(np);
        }
    });
}
function vote_href(uid,pobj) {
    var str = "";
    if (pobj.u.id == uid || uid == -1) { //is owner or not logged in
        return pobj.v.length.toString();
    }
    str += "<div>" + pobj.v.length;
    if ($.inArray(uid,pobj.v) > -1) {
        str += "<a href='#' onclick='devote("+ pobj.id+",this);'>[-]";
    } else {
        str += "<a href='#' onclick='vote("+ pobj.id+",this);'>[+]";
    }
    str += "</a></div>";
    return str;
}

function vote(pid,obj) {
    $.get("/votes/api_add.json?id=" + pid,function(json,code) {
        console.log("api_add");
        console.log(json);
        if(json) {
            var v;
            v = Number(obj.parentNode.firstChild.data) + 1;
            obj.parentNode.innerHTML = v.toString() + "<a href='#' onclick='devote(" + pid + ",this);'>[-]</a>";
            alert("Successfully voted!");
            load_plist_by_filter(current_filter);
        }
    });
}

function devote(pid,obj) {
    $.get("/votes/api_delete.json?id=" + pid,function(json,code) {
        console.log("api_delete");
        console.log(json);
        if(json) {
            var v;
            v = Number(obj.parentNode.firstChild.data) - 1;
            obj.parentNode.innerHTML = v.toString() + "<a href='#' onclick='vote(" + pid + ",this);'>[+]</a>";
            alert("Successfully removed your vote!");
            load_plist_by_filter(current_filter);
        }
    });
}

function show(i) {
    $.get("/posts/api_show.json?id="+i, function (json,code){
        var j,tb,edit;
        console.log("(posts/)api_show");
        console.log(json);
        toggle_container("POST");
        $("tr.is_comment").remove();
        edit = (userid == json.u.id || is_admin) ? "<a href='/posts/" + json.id + "/edit'><img src='/edit.gif' alt='Edit this post'/></a> ":"";
        $("th#ptitle")[0].innerHTML = edit + del_href(json, json.id) + json.t;
        $("th#pauthor")[0].innerHTML = "By:<br/>" +json.u.name;
        $("th#pvotes")[0].innerHTML = "Votes:<br/>" + vote_href(userid,json);
        $("td#pcontent")[0].innerHTML = json.c;
        tb = $("table#pmain")[0];
        for (j = 0; j < json.comments.length; j++) {
            var comment,nc,el;
            comment = json.comments[j];
            tb.appendChild($("<tr class='is_comment'><td colspan='4'><hr></td></tr>")[0]);
            nc = document.createElement("tr");
            el = document.createElement("td");
            edit = (userid == comment.u.id || is_admin) ? "<a href='#' onclick='edit_reply(this," + comment.id + "," + json.id + ");'><img src='/edit.gif' alt='Edit this Post' /></a>" : "";
            el.innerHTML = edit + del_href(json, comment.id) + "<b>" + comment.u.name + "&nbsp;says:</b>";
            el.width = 100;
            nc.appendChild(el);
            nc.appendChild($("<td colspan='2'>" + comment.c + "</td>")[0]);
            el = document.createElement("td");
            el.align = 'middle';
            el.innerHTML = "Votes:<br>" + vote_href(userid,comment);
            nc.appendChild(el);
            $(nc).addClass("is_comment");
            tb.appendChild(nc);
        }
        if (is_login) {
            tb.appendChild($("<tr class='is_comment'><td colspan='4'><hr></td></tr>")[0]);
            nc = document.createElement("tr");
            $(nc).addClass("is_comment");
            nc.appendChild($("<td width='100'>Add Reply:</td>")[0]);
            nc.appendChild($("<td colspan='2'><input type='text' id='reply' /></td>")[0]);
            nc.appendChild($("<td><input type='submit' onclick='reply(" + i + ");' /></td>")[0]);
            tb.appendChild(nc);
        }
    });
}

function reply(post_id) {
    var content;
    content = $("input#reply")[0].value;
    if (content == "") {
        alert("Reply cannot be empty!");
        return;
    }
    $.get('/posts/api_reply.json?post_id=' + post_id + "&content="+content, function (json, code) {
        console.log("api_reply");
        console.log(json);
        if (json) {
            alert("Your reply has been posted!");
            show(post_id);
            load_plist_by_filter(current_filter);
        }
    });
}

function toggle_container(s) {
    if (typeof s !== "string" || s == null) {
        s = is_main_post_toggle ? "USER" : "POST";
    } else {
        s = s.toUpperCase();
    }
    if (s == "POST" && !is_main_post_toggle) {
        is_main_post_toggle = true;
        user_list_el.detach();
        $("a#list_user_link")[0].innerHTML = "List User";
        $("td#right_container").append(main_post_el);
        return;
    }
    if (s == "USER" && is_main_post_toggle) {
        is_main_post_toggle = false;
        main_post_el.detach();
        $("a#list_user_link")[0].innerHTML = "Hide User List";
        $("td#right_container").append(user_list_el);
        return;
    }
}

function del_href(json, id) {
    var i, comment;
    if (id == json.id) {
      if (json.u.id == userid || is_admin) {
            return "<a href='#' onclick='del_post(" + id + ")'><img src='/del.png' alt='Delete this post'/></a>&nbsp;";
      }
      return "";
    }
    for (i = 0; i < json.comments.length; i++) {
        comment = json.comments[i];
        if (comment.id == id) {
            if (comment.u.id == userid || is_admin) {
                return "<a href='#' onclick='del_post(" + id + ",this)'><img src='/del.png' alt='Delete this reply'/></a>&nbsp;";
            }
            return "";
        }
    }
    return "";
}

function del_post(id, obj) {
    $.get("/posts/api_delete.json?id=" + id, function (json,code) {
        var a,i;
        console.log("(posts/)api_delete?id="+id);
        console.log(json);
        if (json.succ == false) {
            return;
        }
        if (typeof obj === "undefined" || obj == null) {
            $("tr.is_comment").remove();
            a = $("table#pmain").find("th");
            for (i = 0; i < a.length; i++) {
                a[i].innerHTML = "";
            }
            $("td#pcontent")[0].innerHTML = "";
            alert("Successfully deleted the post!");
            load_plist_by_filter(current_filter);
        } else {
            alert("Successfully deleted the comment!");
            show(json.p);
            load_plist_by_filter(current_filter);
        }
    });
}

function edit_reply(obj ,id, post_id) {
    var tds,el,old;
    if (edit_lock) {
        alert("You cannot edit more than one reply simultaneously");
        return;
    }
    edit_lock = true;
    tds = obj.parentNode.parentNode.children;
    old = tds[1].childNodes[0].data;
    old = old.substring(0, old.length-2);
    tds[1].innerHTML = "<input type='text' id='reply2'/>";
    $("input#reply2")[0].value = old;
    tds[2].innerHTML = "";
    el = document.createElement("input");
    el.type = "submit";
    el.value = "update";
    el.onclick = function () {
        var content;
        content = $("input#reply2")[0].value;
        if (content == "") {
            alert("Reply cannot be empty!");
            return;
        }
        $.get("/posts/api_reply.json?id=" + id +"&content=" + content, function (json,code) {
            console.log("api_reply?id=" + id +"&content=" + content);
            console.log(json);
            alert("Your reply has been updated!");
            show(post_id);
            edit_lock = false;
        });
    };
    tds[2].appendChild(el);
}