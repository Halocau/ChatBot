<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gemini Chatbot</title>
    <style>
        #chat-toggle-btn {
            position: fixed;
            bottom: 80px;
            right: 20px;
            background-color: white;
            border: none;
            border-radius: 50%;
            box-shadow: 0 2px 6px rgba(0,0,0,0.2);
            width: 50px;
            height: 50px;
            cursor: pointer;
            z-index: 1000;
        }

        #chat-popup {
            position: fixed;
            bottom: 140px;
            right: 20px;
            width: 300px;
            max-height: 400px;
            background-color: #fff;
            border: 1px solid #ccc;
            border-radius: 10px;
            padding: 10px;
            display: none;
            box-shadow: 0 4px 10px rgba(0,0,0,0.3);
            z-index: 999;
        }

        #chatBox {
            height: 250px;
            overflow-y: auto;
            padding: 10px;
            font-family: Arial, sans-serif;
            font-size: 14px;
            color: #333;
        }
    </style>
</head>
<body>

<!-- Nút bật/tắt chat -->
<button id="chat-toggle-btn" onclick="toggleChat()">
    <img src="./images/mess.png" style="width:24px;">
</button>

<!-- Popup chat -->
<div id="chat-popup">
    <div id="chatBox"></div>
    <input type="text" id="userInput" placeholder="Type..." style="width:75%;" onkeydown="if (event.key === 'Enter') sendMessage();">
    <button onclick="sendMessage()">Send</button>
</div>

<script>
    function toggleChat() {
        const chatPopup = document.getElementById("chat-popup");
        chatPopup.style.display = (chatPopup.style.display === "none" || chatPopup.style.display === "") ? "block" : "none";
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
                console.log("Gemini API response: ", response);

                let botReply = response.reply || "(Không có phản hồi từ bot)";
                botReply = botReply.trim();

                const formatted = botReply
                    .replace(/\n/g, "<br>")
                    .replace(/\*\*(.*?)\*\*/g, "<b>$1</b>");

                const chatBox = document.getElementById("chatBox");

                // Tạo phần tử HTML an toàn (tránh lỗi insertAdjacentHTML)
                const userDiv = document.createElement("div");
                userDiv.style.marginBottom = "8px";
                userDiv.innerHTML = `<b>You:</b><br>`;
                const userText = document.createElement("span");
                userText.innerText = userInput;
                userDiv.appendChild(userText);

                const botDiv = document.createElement("div");
                botDiv.style.marginBottom = "8px";
                botDiv.innerHTML = `<b>Bot:</b><br>`;
                const botText = document.createElement("span");
                botText.innerHTML = formatted;
                botDiv.appendChild(botText);

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
