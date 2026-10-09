<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>企业管理系统 · 登录</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", sans-serif;
            background-color: #f5f7fa;
            color: #1a1a1a;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* 登录卡片 */
        .login-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 16px;
            width: 400px;
            padding: 40px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.04);
        }

        /* 标题 */
        .login-header {
            text-align: center;
            margin-bottom: 32px;
        }

        .login-header h1 {
            font-size: 24px;
            font-weight: 600;
            color: #0f172a;
            margin-bottom: 8px;
        }

        .login-header p {
            font-size: 13px;
            color: #94a3b8;
        }

        /* 表单组 */
        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-size: 13px;
            font-weight: 500;
            color: #334155;
        }

        .form-group input {
            width: 100%;
            height: 44px;
            padding: 0 12px;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            font-size: 14px;
            font-family: inherit;
            background: #ffffff;
            transition: all 0.2s;
        }

        .form-group input:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 2px rgba(59,130,246,0.1);
        }

        .form-group input::placeholder {
            color: #cbd5e1;
        }

        /* 错误提示 */
        .error-msg {
            background: #fef2f2;
            border: 1px solid #fecaca;
            border-radius: 10px;
            padding: 10px 14px;
            margin-bottom: 20px;
            font-size: 13px;
            color: #dc2626;
            text-align: center;
        }

        /* 登录按钮 */
        .login-btn {
            width: 100%;
            height: 44px;
            background: #1e293b;
            color: #ffffff;
            border: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
            margin-top: 8px;
        }

        .login-btn:hover {
            background: #0f172a;
        }

        /* 演示信息 */
        .demo-info {
            margin-top: 24px;
            padding-top: 20px;
            border-top: 1px solid #e2e8f0;
            text-align: center;
            font-size: 12px;
            color: #94a3b8;
        }

        .demo-info span {
            background: #f1f5f9;
            padding: 4px 10px;
            border-radius: 20px;
            font-family: monospace;
            margin: 0 4px;
        }

        /* 页脚 */
        .footer {
            margin-top: 24px;
            text-align: center;
            font-size: 11px;
            color: #cbd5e1;
        }
    </style>
</head>
<body>

<div class="login-card">
    <div class="login-header">
        <h1>企业管理系统</h1>
        <p>登录后开始使用</p>
    </div>

    <!-- 错误提示 -->
    <c:if test="${not empty msg}">
        <div class="error-msg">
            ⚠️ ${msg}
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/login" method="post">
        <div class="form-group">
            <label>账号</label>
            <input type="text" name="username" placeholder="请输入账号" required>
        </div>

        <div class="form-group">
            <label>密码</label>
            <input type="password" name="password" placeholder="请输入密码" required>
        </div>

        <button type="submit" class="login-btn">登录</button>
    </form>


    <div class="footer">
        企业管理系统
    </div>
</div>

</body>
</html>