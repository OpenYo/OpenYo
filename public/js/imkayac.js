(function(){
    $('#imSubmit').bind('click', function(){
        var id = localStorage.getItem("id");
        if(id === undefined){
            $('#msgBox').text("ログインしてください。");
            return;
        }
        $.ajax({
            url: '/config/add_imkayac/',
            dataType: 'json',
            data: {
                api_ver: '0.1',
                username: id,
                password: $('#password').val(),
                kayac_id: $('#kayacId').val(),
                kayac_pass: $('#kayacPass').val(),
                kayac_sec: $('#kayacSec').val()
            },
            method: 'POST'
        }).done(function(data){
            $('#msgBox').text(data.result);
        }).fail(function(xhr, status){
            $('#msgBox').text("認証失敗。 パスワードが間違ってる？");
        })
    });
})();
