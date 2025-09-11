<!DOCTYPE html>
<html lang="en">
<head>
    <title>PVJJK TJAS - SSO</title>

    <meta charset="utf-8">
    <meta name="robots" content="noindex, nofollow">

    <link rel="shortcut icon" href="${resourcesPath}/img/favicon.ico" />

    <#if properties.styles?has_content>
        <#list properties.styles?split(' ') as style>
            <link href="${resourcesPath}/${style}" rel="stylesheet" />
        </#list>
    </#if>
</head>

<body>
    <header>
        <h1>TJAS</h1>
        <p>Single Sign-On</p>
    </header>
    <main>
        <a href="admin">Administration Console</a>
        <hr>
        <a href="realms/master/account">Account Management</a>
    </main>
    <footer>
        <p class="copyright">&copy;2025 <a href="https://waren.io">Warén Group</a></p>
    </footer>
</body>
</html>
