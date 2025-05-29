<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gemini Chatbot</title>
    <style>
        :root {
            --main-color: #2e7d32; /* Xanh đậm lá cây */
            --text-color: #fff;
        }

        body {
            margin: 0;
            font-family: "Segoe UI", sans-serif;
        }

        #chat-toggle-btn {
            position: fixed;
            bottom: 100px;
            right: 30px;
            background-color: var(--main-color);
            border: none;
            border-radius: 50%;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
            width: 60px;
            height: 60px;
            cursor: pointer;
            z-index: 1000;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        #chat-toggle-btn img {
            width: 28px;
            height: 28px;
            filter: brightness(0) invert(1);
        }

        #chat-popup {
            position: fixed;
            bottom: 170px;
            right: 30px;
            width: 330px;
            height: 400px;
            background-color: #fff;
            border-radius: 16px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.2);
            display: none;
            flex-direction: column;
            overflow: hidden;
            z-index: 999;
            border: 2px solid var(--main-color);
        }

        #chatBox {
            flex: 1;
            overflow-y: auto;
            padding: 16px;
            font-size: 15px;
            color: #333;
        }

        #chatBox div {
            margin-bottom: 12px;
        }

        #chat-popup input[type="text"] {
            width: calc(100% - 90px);
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 14px;
            margin-left: 10px;
        }

        #chat-popup button.send-btn {
            padding: 10px 14px;
            margin-left: 6px;
            margin-right: 10px;
            background-color: var(--main-color);
            color: var(--text-color);
            border: none;
            border-radius: 8px;
            cursor: pointer;
        }

        #chat-footer {
            display: flex;
            padding: 10px 0;
            border-top: 1px solid #eee;
            align-items: center;
        }
    </style>
</head>
<body>

<!-- Nút bật/tắt chat -->
<button id="chat-toggle-btn" onclick="toggleChat()">
    <img src="./images/mess.png" alt="Chat">
</button>

<!-- Popup chat -->
<div id="chat-popup">
    <div id="chatBox"></div>
    <div id="chat-footer">
        <input type="text" id="userInput" placeholder="Nhập nội dung..." onkeydown="if (event.key === 'Enter') sendMessage();">
        <button class="send-btn" onclick="sendMessage()">Gửi</button>
    </div>
</div>

<script>
    function toggleChat() {
        const chatPopup = document.getElementById("chat-popup");
        chatPopup.style.display = (chatPopup.style.display === "none" || chatPopup.style.display === "") ? "flex" : "none";
    }

    function sendMessage() {
        const userInput = document.getElementById("userInput").value.trim();
        if (!userInput) return;

        const xhr = new XMLHttpRequest();
        xhr.open("POST", "chatbot", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");

        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4 && xhr.status === 200) {
                const response = JSON.parse(xhr.responseText);
                let botReply = response.reply || "(Không có phản hồi từ bot)";
                botReply = botReply.trim();

                const formatted = botReply
                    .replace(/\n/g, "<br>")
                    .replace(/\*\*(.*?)\*\*/g, "<b>$1</b>");

                const chatBox = document.getElementById("chatBox");

                // Tạo phần tử người dùng
                const userDiv = document.createElement("div");
                userDiv.innerHTML = `<b>You:</b><br>`;
                const userText = document.createElement("span");
                userText.innerText = userInput;
                userDiv.appendChild(userText);

                // Tạo phần tử bot
                const botDiv = document.createElement("div");
                botDiv.innerHTML = `<b>Bot:</b><br>`;
                const botText = document.createElement("span");
                botText.innerHTML = formatted;
                botDiv.appendChild(botText);

                // Thêm vào chat
                chatBox.appendChild(userDiv);
                chatBox.appendChild(botDiv);

                document.getElementById("userInput").value = "";
                chatBox.scrollTop = chatBox.scrollHeight;
            }
        };

        xhr.send("message=" + encodeURIComponent(userInput));
    }
</script>

</body>
</html>
