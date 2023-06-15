<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header d-sm-flex align-items-center justify-content-between">
                <h4 class="card-title"><?php echo $pagename ?></h4>
                <div>
                    <a class="btn btn-primary" href="<?php echo $page['url'] ?>"> Back </a>
                    <?php 
                    if($data->status == "1"){
                        ?><a class="btn btn-danger" href="<?php echo $page['url'].'/close/'.$data->id ?>"> Close </a><?php
                    }else if($data->status == "0"){
                        ?><a class="btn btn-primary" href="<?php echo $page['url'].'/reopen/'.$data->id ?>"> Reopen </a><?php
                    }
                    ?>
                </div>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-xl-6 col-lg-8 col-md-10">
                        <div class="chatbody">
                            <div class="panel panel-primary">
                                <div class="panel-heading top-bar">
                                    <div class="d-flex justify-content-between">
                                        <h4 class="panel-title mt-0">Chat : <?= $data->name; ?></h4>
                                        <!-- <h6 class="panel-title mt-0">Status : <?php //echo $userdata->status == "1" ? "Open" : "Closed" ?></h6> -->
                                        <h6 class="panel-title mt-0">Status : <?= $data->status == "1" ? "Open" : "Closed" ?></h6>
                                    </div>
                                    <h6 class="panel-title mt-0">Date : <?= $data->createdDateSimple ?></h6>
                                    <h6 class="panel-title mt-0">Created by : <?= $data->name ?></h6>
                                    <h6 class="panel-title mt-0"><?= $data->title ?></h6>
                                    <p class="panel-title mt-0"><?= $data->description ?></p>
                                </div>
                                <div class="row" id="mainLoader">
                                    <div class="col-md-12 text-center my-3">
                                        <div class="spinner-grow text-primary" role="status">
                                            <span class="sr-only">Loading...</span>
                                        </div>
                                        <div class="spinner-grow text-primary" role="status">
                                            <span class="sr-only">Loading...</span>
                                        </div>
                                        <div class="spinner-grow text-primary" role="status">
                                            <span class="sr-only">Loading...</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="need-help-body d-none">
                                    <div class="panel-body msg_container_base chat">   
                                    </div>
                                    <div class="panel-footer">
                                        <div class="input-group">
                                            <input id="message_box" type="text" class="form-control input-sm chat_input" placeholder="Write your message here..." />
                                            <span class="input-group-btn p-0">
                                                <button class="btn btn-primary btn-block m-0 need-help-send-btn" onclick="sendMessage()"><i class="fas fa-paper-plane fa-2x"></i></button>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    //var conn = new WebSocket('ws://192.168.0.108:8387');

    const RECONNECT_IN_SEC = 10
    var userId = '<?php echo $data->userId ?>';
    var ticketStatus = '<?php echo $data->status ?>';
    var curruntActiveChat = '<?php echo isset($id) && !empty($id) ? $id : "" ?>';
    if(curruntActiveChat != ''){
        let ws = {
            /**
            * Start the connection
            * @type {WebSocket}
            */
            conn: null,
        }
        WebSocket.prototype.reconnect = function(callback) {
            if (this.readyState === WebSocket.OPEN || this.readyState !== WebSocket.CONNECTING) {
                this.close()
            }
            //console.log("Reconnect Off");
            callback()
            // let seconds = RECONNECT_IN_SEC
            // // //let container = "";
            // let countHandle = setInterval(() => {
            //     console.log(seconds);
            //     if (--seconds <= 0) {
            //         clearInterval(countHandle)
            //         //delete container
            //         alert("Fail to connect");
            //         callback()
            //     }
            //     //container.text(seconds.toString())
            // }, 1000)
        }
        let connect = function() {
            if (ws.conn) {
                if (ws.conn.readyState === WebSocket.OPEN || ws.conn.readyState == WebSocket.CONNECTING) {
                    ws.conn.close()
                }
                delete ws.conn
            }
            ws.conn = new WebSocket("<?php echo getenv('WEBSOCKETSERVER') ?>");
            ws.conn.onopen = function(event) {
                console.log('Connection established!');
                $("#mainLoader").addClass("d-none");
                $(".need-help-body").removeClass("d-none");
                register_client();
                chatinbox();
            }
            ws.conn.onmessage = function(event) {
                var eventData = jQuery.parseJSON(event.data);
                // console.log(eventData);
                // console.log(eventData.hookMethod);
                switch(eventData.hookMethod) {
                    case 'userSupportTicketMessageList':
                        if(eventData.data == ''){
                            $(".chat").append(`<h6 class="no-message text-center my-3">No Messages</h6>`)
                            return false;
                        }
                        eventData.data.forEach(function(item, index, array) {
                            console.log(item);
                            if(item.forReply == '1'){
                                $(".chat").append(`
                                    <div class="single-need-chat user-chat py-2">
                                        <div class="d-flex align-items-center justify-content-end flex-sm-row flex-column">
                                            <div class="order-sm-1 order-2 d-block mobchatcenter">
                                                <p class="mb-0 text-right own-text">`+item.description+`</p>
                                                <p class="mb-0 chatsendtime">`+item.foramted_date+`</p>
                                            </div>
                                            <div class="need-chat-person text-center ml-sm-3 order-sm-2 order-1  mb-sm-0 mb-3">
                                                <img src="`+item.profileimage+`" onerror="this.onerror=null;this.src='<?php echo base_url('assets/backend/img/default-avatar.png'); ?>';" class="chatuserimg" alt="">
                                                <p class="mb-0 chatsendername">You</p>
                                            </div>
                                        </div>
                                    </div>
                                `);
                            }else if(item.forReply == '2' && item.replyType == '1'){
                                $(".chat").append(`
                                    <div class="single-need-chat user-chat py-2">
                                        <div class="d-sm-flex align-items-center">
                                            <div class="need-chat-person text-center mr-sm-3  mb-sm-0 mb-3">
                                                <img src="`+item.profileimage+`" onerror="this.onerror=null;this.src='<?php echo base_url('assets/backend/img/default-avatar.png'); ?>';" class="chatuserimg" alt="">
                                                <p class="mb-0 chatsendername">`+item.senderName+`</p>
                                            </div>
                                            <div class="d-block mobchatcenter">
                                                <p class="mb-0 other-text">`+item.description+`</p>
                                                <p class="mb-0 chatsendtime">`+item.foramted_date+`</p>
                                            </div>
                                        </div>
                                    </div>
                                `);
                            }else if(item.forReply == '2' && item.replyType == '2'){
                                $(".chat").append(`
                                    <div class="single-need-chat user-chat py-2">
                                        <div class="d-sm-flex align-items-center">
                                            <div class="need-chat-person text-center mr-sm-3  mb-sm-0 mb-3">
                                                <img src="`+item.profileimage+`" onerror="this.onerror=null;this.src='<?php echo base_url('assets/backend/img/default-avatar.png'); ?>';" class="chatuserimg" alt="">
                                                <p class="mb-0 chatsendername">`+item.senderName+`</p>
                                            </div>
                                            <div class="d-block mobchatcenter">
                                                <img src="`+item.description+`" onerror="this.onerror=null;this.src='<?php echo base_url('assets/backend/img/no-img.png'); ?>';" class=" img-responsive img chatrplyimg">
                                                <p class="mb-0 chatsendtime">`+item.foramted_date+`</p>
                                            </div>
                                        </div>
                                    </div>
                                `);
                            }
                        });
                        setTimeout( function() {
                            $(".chat").animate({ scrollTop: $('.chat')[0].scrollHeight}, 500);
                        }, 500);
                        break;
                    case 'userSupportTicketReply':
                        $(".need-help-send-btn").html('<i class="fas fa-paper-plane fa-2x"></i>');
                        $(".need-help-send-btn").attr('disabled',false);
                        item = eventData.data;
                        if(item.forReply == '1' && item.ticketId == curruntActiveChat){
                            $(".no-message").remove();  
                            $(".chat").append(`
                                <div class="single-need-chat user-chat py-2">
                                    <div class="d-flex align-items-center justify-content-end flex-sm-row flex-column">
                                        <div class="order-sm-1 order-2 d-block mobchatcenter">
                                            <p class="mb-0 text-right own-text">`+item.description+`</p>
                                            <p class="mb-0 chatsendtime">`+item.foramted_date+`</p>
                                        </div>
                                        <div class="need-chat-person text-center ml-sm-3 order-sm-2 order-1  mb-sm-0 mb-3">
                                            <img src="`+item.profileimage+`" onerror="this.onerror=null;this.src='<?php echo base_url('assets/backend/img/default-avatar.png'); ?>';" class="chatuserimg" alt="">
                                            <p class="mb-0 chatsendername">You</p>
                                        </div>
                                    </div>
                                </div>
                            `);
                        }else if(item.forReply == '2' && item.replyType == '1' && item.ticketId == curruntActiveChat){
                            $(".no-message").remove();  
                            $(".chat").append(`
                                <div class="single-need-chat user-chat py-2">
                                    <div class="d-sm-flex align-items-center">
                                        <div class="need-chat-person text-center mr-sm-3  mb-sm-0 mb-3">
                                            <img src="`+item.profileimage+`" onerror="this.onerror=null;this.src='<?php echo base_url('assets/backend/img/default-avatar.png'); ?>';" class="chatuserimg" alt="">
                                            <p class="mb-0 chatsendername">`+item.senderName+`</p>
                                        </div>
                                        <div class="d-block mobchatcenter">
                                            <p class="mb-0 other-text">`+item.description+`</p>
                                            <p class="mb-0 chatsendtime">`+item.foramted_date+`</p>
                                        </div>
                                    </div>
                                </div>
                            `);
                        }else if(item.forReply == '2' && item.replyType == '2' && item.ticketId == curruntActiveChat){
                            $(".no-message").remove();  
                            $(".chat").append(`
                                <div class="single-need-chat user-chat py-2">
                                    <div class="d-sm-flex align-items-center">
                                        <div class="need-chat-person text-center mr-sm-3  mb-sm-0 mb-3">
                                            <img src="`+item.profileimage+`" onerror="this.onerror=null;this.src='<?php echo base_url('assets/backend/img/default-avatar.png'); ?>';" class="chatuserimg" alt="">
                                            <p class="mb-0 chatsendername">`+item.senderName+`</p>
                                        </div>
                                        <div class="d-block mobchatcenter">
                                            <img src="`+item.description+`" onerror="this.onerror=null;this.src='<?php echo base_url('assets/backend/img/no-img.png'); ?>';" class=" img-responsive img chatrplyimg">
                                            <p class="mb-0 chatsendtime">`+item.foramted_date+`</p>
                                        </div>
                                    </div>
                                </div>
                            `);
                        }
                        $(".chat").animate({ scrollTop: $('.chat')[0].scrollHeight}, 500);
                        break;
                    default:
                        console.log("Unknown Case");
                }
                //console.log('On Message Event')
            }
            ws.conn.onclose = function(event) {
                //console.log('Connection closed!')
                $("#mainLoader").removeClass("d-none");
                $(".need-help-body").addClass("d-none");
                if (event.target.readyState === WebSocket.CLOSING || event.target.readyState === WebSocket.CLOSED) {
                    event.target.reconnect(connect)
                }
            }
            ws.conn.onerror = function(event) {
                $("#mainLoader").removeClass("d-none");
                $(".need-help-body").addClass("d-none");
                //console.log('We have received an error!')
            }
        }
        document.addEventListener('DOMContentLoaded', connect)
        function register_client(){  
            let data = {
                'token': "<?php echo $this->input->cookie('xhAdminSessionCookie'); ?>",
                'hookMethod': 'registration',
            }
            if (ws.conn && ws.conn.readyState === WebSocket.OPEN) {
                ws.conn.send(JSON.stringify(data));
            }
        }
        function chatinbox(){
            $(".chat").html('');
            let data = {
                'hookMethod': 'userSupportTicketMessageList',
                'ticket_id': curruntActiveChat,
            }
            if (ws.conn && ws.conn.readyState === WebSocket.OPEN) {
                ws.conn.send(JSON.stringify(data));
            }
        }

        $(window).on('keydown', function(e) {
            if (e.which == 13) {     
                if($("#message_box").val().trim()!=""){          
                    sendMessage();
                    return false;
                }
            }
        });

        function sendMessage(){

            if(ticketStatus == '0'){
                return false;
            }
            
            var msg = $('#message_box').val();
            if(msg.trim() == ""){
                return false;
            }
            let data = {
                'ticket_id': curruntActiveChat,
                'hookMethod': 'userSupportTicketReply',
                'description': msg,
                'replyType': 1,
            }
            if (ws.conn && ws.conn.readyState === WebSocket.OPEN) {
                ws.conn.send(JSON.stringify(data));
            }
            $('#message_box').val('');
            $(".need-help-send-btn").html("<div class='spinner-border' role='status'><span class='sr-only'>Loading...</span></div>");
            $(".need-help-send-btn").attr('disabled',true);
        }

        function setActive(){
            
        }
        function checkinboxchat(){

        }
    }    
</script>
