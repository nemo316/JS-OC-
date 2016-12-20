
// js调用oc
window.onload = function(){
    // 拿到所有的图片
    var allImg = document.getElementsByTagName("img");
    // 遍历(监听每张图片的点击)
    for(var i = 0; i < allImg.length; i ++){
        // 取出单个图片对象
        var img = allImg[i];
        // 绑定一个id
        img.id = i;
        // 监听点击
        img.onclick = function(){
//            alert('点击了'+this.id+'张');
            // 跳转
//            window.location.href = 'http://www.baidu.com';
             window.location.href = 'wxh:///openCamera';
        }
    }
    // oc修改js
    // 往网页尾部加入一张图片
    var img = document.createElement('img');
    img.src = 'https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/bd_logo1_31bdc765.png';
    document.body.appendChild(img);
}
