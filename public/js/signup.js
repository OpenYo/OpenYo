(function(){
    window.addEventListener('load', function(){
        var user = localStorage.getItem('id');
        if(!!user){
            $('#head').html('Yo ' + user + '! Go <a href="/mypage/">MyPage</a>');
            $('#auth').attr('disabled', true);
        }
    });
    $('#create').bind('click', function(){
        $.ajax({
            url: '/config/create_user/',
            dataType: 'json',
            data: {
                api_ver: '0.1',
                username: $('#id').val(),
                password: $('#pass').val()
            },
            method: 'POST'
        }).done(function(data){
             if(data.code == "200"){
                 $('#msgBox').html('登録成功です。<br>Go <a href="/mypage/">MyPage</a>');
                 localStorage.setItem('id', $('#id').val());
                 localStorage.setItem('apiToken', data.result);
             } else {
                 $('#msgBox').text(data.result);
             }
        }).fail(function(xhr){
        })
    });
})();
