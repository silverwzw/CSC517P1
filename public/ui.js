var is_login, username, is_admin, userid, user_list_el, main_post_el, is_main_post_toggle;
is_login = false;
username = "";
userid = -1;
is_admin = false;
function load() {
    user_list_el = $("div#user_list");
    main_post_el = $("table#pmain");
    is_main_post_toggle = true;
    user_list_el.detach();
    $.get("/users/api_is_login.json",function (json,code) {
        console.log("api_is_login");
        console.log(json);
        console.log(code);
        if (json != null) {
            $("th#nav1")[0].innerHTML = "<a href='/users/" + json.id + "/edit' target='_blank'>" + json.name + "</a>, welcome back! <a href='/users/login?user[name]=logout'>logout</a>"
            username = json.name;
            userid = json.id;
            is_login = true;
        } else {
            var str;
            str = "<form action='/users/login' method='POST'>name:<input type='text' name='user[name]' size=6/>password:<input type='password' name='user[password]' size=6/><input type='submit' value='login'>";
            str += "or <a href='/users/new' target='_blank'>Register!</a></form>";
            $("th#nav1")[0].innerHTML += str;
            is_login = false;
        }
    });
    $.get("/users/api_is_admin.json", function (json,code){
        var l;
        console.log("api_is_admin");
        console.log(json);
        console.log(code);
        if (json) {
            $("th#nav2")[0].innerHTML = "<a href='/users' target='_blank'>Manage Users</a>";
        } else {
            $("th#nav2")[0].innerHTML = "<a href='#' id='list_user_link'></a>";
            l = $("a#list_user_link")[0];
            l.innerHTML = "List users";
            l.onclick =toggle_container;
            $.get('/users/api_list.json', function (json,code) {
                var list, i;
                console.log("(users/)api_list");
                console.log(json);
                console.log(code);
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
    load_plist_by_filter("");
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
        console.log(code);
        tb = $("table#plists").find("tbody")[0];
        trs = $(tb).find("tr");
        for (i = 1; i < trs.length; i++) {
            trs[i].remove();
        }
        for (i = 0; i < json.length; i++) {
            np = document.createElement("tr");
            el = document.createElement("td");
            el.innerHTML = "[" + json[i].category.n + "]&nbsp;<a href='javascript:show(" + json[i].id + ")'>" + json[i].t + "</a>";
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
        str += "<a href='#' onclick='devote("+ pobj.id+",this);'>(-)";
    } else {
        str += "<a href='#' onclick='vote("+ pobj.id+",this);'>(+)";
    }
    str += "</a></div>";
    return str;
}

function vote(pid,obj) {
    $.get("/votes/api_add.json?id=" + pid,function(json,code) {
        console.log("api_add");
        console.log(json);
        console.log(code);
        if(json) {
            var v;
            v = Number(obj.parentNode.firstChild.data) + 1;
            obj.parentNode.innerHTML = v.toString() + "<a href='#' onclick='devote(" + pid + ",this);'>(-)</a>";
        }
    });
}

function devote(pid,obj) {
    $.get("/votes/api_delete.json?id=" + pid,function(json,code) {
        console.log("api_delete");
        console.log(json);
        console.log(code);
        if(json) {
            var v;
            v = Number(obj.parentNode.firstChild.data) - 1;
            obj.parentNode.innerHTML = v.toString() + "<a href='#' onclick='vote(" + pid + ",this);'>(+)</a>";
        }
    });
}

function show(i) {
    $.get("/posts/api_show.json?id="+i, function (json,code){
        var j,tb;
        console.log("(posts/)api_show");
        console.log(json);
        console.log(code);
        toggle_container("POST");
        $("tr.is_comment").remove();
        $("th#ptitle")[0].innerHTML = json.t;
        $("th#pauthor")[0].innerHTML = json.u.name;
        $("th#pvotes")[0].innerHTML = vote_href(userid,json);
        $("td#pcontent")[0].innerHTML = json.c;
        tb = $("table#pmain")[0];
        for (j = 0; j < json.comments.length; j++) {
            var comment,nc,el;
            comment = json.comments[j];
            tb.appendChild($("<tr class='is_comment'><td colspan='4'><hr></td></tr>")[0]);
            nc = document.createElement("tr");
            el = document.createElement("td");
            el.innerHTML = "<b>" + comment.u.name + "&nbsp;says:</b>";
            el.width = 80;
            nc.appendChild(el);
            nc.appendChild($("<td colspan='2'>" + comment.c + "</td>")[0]);
            el = document.createElement("td");
            el.align = 'middle';
            el.innerHTML = vote_href(userid,comment);
            nc.appendChild(el);
            $(nc).addClass("is_comment");
            tb.appendChild(nc);
        }
    });
}

function toggle_container(s) {
    if (typeof s !== "string" || s == null) {
        s = is_main_post_toggle ? "USER" : "POST";
    } else {
        s = s.toUpperCase();
    }
    console.log("toggle");
    console.log(s);
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