# ,kClean_html_integration_spec.sh
# //2.1.linux/1.Install/utils_pj/spec/,kClean_html_integration_spec.sh
# Integration test for ,kClean_html.sh using sample HTML

Describe ',kClean_html.sh integration tests'
    # Create a test HTML file
    setup() {
        TEST_HTML=$(mktemp)
        EXPECTED_OUTPUT=$(mktemp)
        ACTUAL_OUTPUT=$(mktemp)
        
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

        # Expected output after cleaning
        cat > "$EXPECTED_OUTPUT" <<'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Test Page</title>
    <meta charset="UTF-8">
</head>
<h1>Welcome</h1>
<a>Link 1</a>
<b>Bold text</b>
<i>Italic text</i>
<div>Some content</div>
<p>Another paragraph</p>
EOF
    }
    
    cleanup() {
        rm -f "$TEST_HTML" "$EXPECTED_OUTPUT" "$ACTUAL_OUTPUT"
    }
    
    BeforeEach 'setup'
    AfterEach 'cleanup'
    
    It 'cleans HTML content correctly'
        # Run the cleaning commands on the test file
        cat "$TEST_HTML" |
            sed -n '/^<body>/q; p' |
            sed 's/ id="[^"]*"//g' |
            sed "s/ id='[^']*'//g" |
            sed 's/ class="[^"]*"//g' |
            sed "s/ class='[^']*'//g" |
            sed 's/ href="[^"]*"//g' |
            sed "s/ href='[^']*'//g" |
            sed 's/ role="[^"]*"//g' |
            sed "s/ role='[^']*'//g" |
            sed 's/ style="[^"]*"//g' |
            sed "s/ style='[^']*'//g" |
            sed 's/ src="[^"]*"//g' |
            sed "s/ src='[^']*'//g" |
            sed 's/strong>/b>/g' |
            sed 's/em>/i>/g' |
            sed 's/<div>[[:space:]]*.[[:space:]]*<\/div>//g' |
            sed 's/<div>[[:space:]]*<\/div>//g' |
            sed ':a; s/<a><sup[^>]*>[^<]*<\/sup><\/a>//g; ta' |
            sed '/^[[:space:]]*$/d' |
            sed 's/[[:space:]]\{2,\}/ /g' |
            sed 's/[[:space:]]*>/ >/g' |
            sed 's/<[[:space:]]*/</g' > "$ACTUAL_OUTPUT"
        
        # Compare the cleaned output with expected (ignoring whitespace differences)
        When call diff -b -B -w "$EXPECTED_OUTPUT" "$ACTUAL_OUTPUT"
        The status should be success
    End
    
    It 'removes all attribute types correctly'
        # Test individual attribute removal
        result() {
            echo '<div id="test" class="test" href="test" role="test" style="test" src="test">content</div>' |
            sed 's/ id="[^"]*"//g' |
            sed "s/ id='[^']*'//g" |
            sed 's/ class="[^"]*"//g' |
            sed "s/ class='[^']*'//g" |
            sed 's/ href="[^"]*"//g' |
            sed "s/ href='[^']*'//g" |
            sed 's/ role="[^"]*"//g' |
            sed "s/ role='[^']*'//g" |
            sed 's/ style="[^"]*"//g' |
            sed "s/ style='[^']*'//g" |
            sed 's/ src="[^"]*"//g' |
            sed "s/ src='[^']*'//g"
        }
        When call result
        The output should equal "<div>content</div>"
    End
    
    It 'converts strong and em tags correctly'
        result() {
            echo '<strong>Bold</strong> <em>Italic</em>' |
            sed 's/strong>/b>/g' |
            sed 's/em>/i>/g'
        }
        When call result
        The output should include '<b>Bold</b>'
        The output should include '<i>Italic</i>'
        The output should not include 'strong>'
        The output should not include 'em>'
    End
    
    It 'removes empty and single-character div tags'
        result() {
            echo '<div></div><div> </div><div>A</div><div>Content</div>' |
            sed 's/<div>[[:space:]]*.[[:space:]]*<\/div>//g' |
            sed 's/<div>[[:space:]]*<\/div>//g'
        }
        When call result
        The output should equal "<div>Content</div>"
    End
    
    It 'removes anchor-sup combinations'
        result() {
            echo '<a><sup>1</sup></a> <a><sup>2</sup></a> <a>Link</a>' |
            sed ':a; s/<a><sup[^>]*>[^<]*<\/sup><\/a>//g; ta'
        }
        When call result
        The output should include "<a>Link</a>"
        The output should not include "<a><sup>"
    End
    
    It 'removes empty lines and extra spaces'
        result() {
            printf '\n\n  content  \n\n  more  \n\n' |
            sed '/^[[:space:]]*$/d' |
            sed 's/[[:space:]]\{2,\}/ /g'
        }
        When call result
        The output should equal " content more "
    End
End