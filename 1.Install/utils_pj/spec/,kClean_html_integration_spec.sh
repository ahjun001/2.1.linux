# spec/,kClean_html_integration_spec.sh
# Integration tests for ,kClean_html.sh

Describe ',kClean_html.sh integration tests'
    setup() {
        TEST_HTML=$(mktemp)
        EXPECTED_OUTPUT=$(mktemp)
        
        cat > "$TEST_HTML" <<'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Test Page</title>
    <meta charset="UTF-8">
</head>
<body>
    <div id="main" class="container" role="main" style="color:red;font-size:16px;">
        <h1 id="title" class="header">Welcome</h1>
        <a href="https://example.com" id="link1" class="external" role="navigation">Link 1</a>
        <strong>Bold text</strong>
        <em>Italic text</em>
        <div>Some content</div>
        <div></div>
        <div> </div>
        <div>A</div>
        <a><sup>1</sup></a>
        <a><sup>2</sup></a>
        <p class="text" style="margin:10px;">Another paragraph</p>
    </div>
</body>
</html>
EOF

        # Expected output - match what the script produces
        # The script removes div tags but keeps content with a space before "Some content"
        cat > "$EXPECTED_OUTPUT" <<'EOF'
<h1>Welcome</h1><a>Link 1</a><b>Bold text</b><i>Italic text</i> Some content A<p>Another paragraph</p>
EOF
    }
    
    cleanup() {
        rm -f "$TEST_HTML" "$EXPECTED_OUTPUT"
    }
    
    BeforeEach 'setup'
    AfterEach 'cleanup'
    
    It 'cleans HTML content correctly using the actual script'
        export TEST_MODE=1
        export SOURCE_HTML="$(cat "$TEST_HTML")"
        
        result() {
            /home/perubu/Documents/Github/2.1.linux/1.Install/utils_pj/,kClean_html.sh
        }
        
        When call result
        The output should eq "$(cat "$EXPECTED_OUTPUT")"
    End
    
    It 'removes all attributes from HTML'
        export TEST_MODE=1
        export SOURCE_HTML='<body><div id="test" class="test" href="test" role="test" style="test" src="test">content</div></body>'
        
        result() {
            /home/perubu/Documents/Github/2.1.linux/1.Install/utils_pj/,kClean_html.sh
        }
        
        When call result
        # The script removes div tags but keeps content
        The output should eq "content"
    End
    
    It 'converts strong and em tags'
        export TEST_MODE=1
        export SOURCE_HTML='<body><strong>Bold</strong> <em>Italic</em></body>'
        
        result() {
            /home/perubu/Documents/Github/2.1.linux/1.Install/utils_pj/,kClean_html.sh
        }
        
        When call result
        The output should include '<b>Bold</b>'
        The output should include '<i>Italic</i>'
        The output should not include 'strong>'
        The output should not include 'em>'
    End
    
    It 'removes div tags but keeps content'
        export TEST_MODE=1
        export SOURCE_HTML='<body><div></div><div> </div><div>A</div><div>Content</div></body>'
        
        result() {
            /home/perubu/Documents/Github/2.1.linux/1.Install/utils_pj/,kClean_html.sh
        }
        
        When call result
        The output should eq "AContent"
    End
    
    It 'removes anchor-sup combinations'
        export TEST_MODE=1
        export SOURCE_HTML='<body><a><sup>1</sup></a> <a><sup>2</sup></a> <a>Link</a></body>'
        
        result() {
            /home/perubu/Documents/Github/2.1.linux/1.Install/utils_pj/,kClean_html.sh
        }
        
        When call result
        The output should include "<a>Link</a>"
        The output should not include "<a><sup>"
    End
End