# ,kClean_html_spec.sh
# //2.1.linux/1.Install/utils_pj/spec/,kClean_html_spec.sh
# ShellSpec test script for ,kClean_html.sh

Describe ',kClean_html.sh sed transformations'
    # Sample HTML content for testing
    SampleHTML() {
        cat <<'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Test Page</title>
</head>
<body>
    <div id="main" class="container" role="main" style="color:red">
        <a href="https://example.com" id="link1" class="external" role="navigation">Link</a>
        <strong>Bold text</strong>
        <em>Italic text</em>
        <div>Some content</div>
        <div></div>
        <div> </div>
        <a><sup>1</sup></a>
        <a><sup>2</sup></a>
        <p>Another paragraph</p>
    </div>
</body>
</html>
EOF
    }
    
    Describe 'sed -n "/^<body>/q; p"'
        It 'extracts content before <body> tag'
            result() { echo "$(SampleHTML | sed -n '/^<body>/q; p')"; }
            When call result
            The output should include "<head>"
            The output should include "<title>"
            The output should not include "<body>"
        End
    End
    
    Describe 'sed "s/ id=[^>]*>/>/g"'
        It 'removes id attributes'
            result() { echo '<div id="main" class="test">content</div>' | sed 's/ id=[^>]*>/>/g'; }
            When call result
            The output should include '<div class="test">'
            The output should not include 'id='
        End
        
        It 'removes id attributes with single quotes'
            result() { echo "<div id='main' class='test'>content</div>" | sed "s/ id=[^>]*>/>/g"; }
            When call result
            The output should include "<div class='test'>"
            The output should not include 'id='
        End
    End
    
    Describe 'sed "s/ class=[^>]*>/>/g"'
        It 'removes class attributes'
            result() { echo '<div id="main" class="container" role="main">content</div>' | sed 's/ class=[^>]*>/>/g'; }
            When call result
            The output should include '<div id="main" role="main">'
            The output should not include 'class='
        End
        
        It 'removes class attributes with single quotes'
            result() { echo "<div id='main' class='container' role='main'>content</div>" | sed "s/ class=[^>]*>/>/g"; }
            When call result
            The output should include "<div id='main' role='main'>"
            The output should not include 'class='
        End
    End
    
    Describe 'sed "s/ href=[^>]*>/>/g"'
        It 'removes href attributes'
            result() { echo '<a href="https://example.com" id="link">Link</a>' | sed 's/ href=[^>]*>/>/g'; }
            When call result
            The output should include '<a id="link">'
            The output should not include 'href='
        End
        
        It 'removes href attributes with single quotes'
            result() { echo "<a href='https://example.com' id='link'>Link</a>" | sed "s/ href=[^>]*>/>/g"; }
            When call result
            The output should include "<a id='link'>"
            The output should not include 'href='
        End
    End
    
    Describe 'sed "s/ role=[^>]*>/>/g"'
        It 'removes role attributes'
            result() { echo '<div id="main" class="container" role="main">content</div>' | sed 's/ role=[^>]*>/>/g'; }
            When call result
            The output should include '<div id="main" class="container">'
            The output should not include 'role='
        End
    End
    
    Describe 'sed "s/ style=[^>]*>/>/g"'
        It 'removes style attributes'
            result() { echo '<div style="color:red;font-size:16px;" class="test">content</div>' | sed 's/ style=[^>]*>/>/g'; }
            When call result
            The output should include '<div class="test">'
            The output should not include 'style='
        End
    End
    
    Describe 'sed "s/ src=[^>]*>/>/g"'
        It 'removes src attributes'
            result() { echo '<img src="image.jpg" alt="image" class="test">' | sed 's/ src=[^>]*>/>/g'; }
            When call result
            The output should include '<img alt="image" class="test">'
            The output should not include 'src='
        End
    End
    
    Describe 'sed "s/strong>/b>/g"'
        It 'converts strong tags to b tags'
            result() { echo '<strong>Bold text</strong>' | sed 's/strong>/b>/g'; }
            When call result
            The output should include '<b>Bold text</b>'
            The output should not include 'strong>'
        End
    End
    
    Describe 'sed "s/em>/i>/g"'
        It 'converts em tags to i tags'
            result() { echo '<em>Italic text</em>' | sed 's/em>/i>/g'; }
            When call result
            The output should include '<i>Italic text</i>'
            The output should not include 'em>'
        End
    End
    
    Describe 'sed "s/<div>\b.<\/div>//g"'
        It 'removes div tags with single character content'
            result() { echo '<div>A</div>' | sed 's/<div>\b.<\/div>//g'; }
            When call result
            The output should be blank
        End
        
        It 'does not remove div tags with longer content'
            result() { echo '<div>ABC</div>' | sed 's/<div>\b.<\/div>//g'; }
            When call result
            The output should include '<div>ABC</div>'
        End
    End
    
    Describe 'sed "s/<div>[[:space:]]*<\/div>//g"'
        It 'removes empty div tags'
            result() { echo '<div></div>' | sed 's/<div>[[:space:]]*<\/div>//g'; }
            When call result
            The output should be blank
        End
        
        It 'removes div tags with only whitespace'
            result() { echo '<div> </div>' | sed 's/<div>[[:space:]]*<\/div>//g'; }
            When call result
            The output should be blank
        End
        
        It 'removes div tags with newlines'
            result() { printf '<div>\n\n</div>' | sed 's/<div>[[:space:]]*<\/div>//g'; }
            When call result
            The output should be blank
        End
    End
    
    Describe 'sed ":a; s/<a><sup[^>]*>[^<]*<\/sup><\/a>//g; ta"'
        It 'removes anchor tags containing sup tags'
            result() { echo '<a><sup>1</sup></a>' | sed ':a; s/<a><sup[^>]*>[^<]*<\/sup><\/a>//g; ta'; }
            When call result
            The output should be blank
        End
        
        It 'removes multiple anchor-sup combinations'
            result() { echo '<a><sup>1</sup></a> <a><sup>2</sup></a>' | sed ':a; s/<a><sup[^>]*>[^<]*<\/sup><\/a>//g; ta'; }
            When call result
            The output should be blank
        End
    End
    
    Describe 'sed "/^[[:space:]]*$/d"'
        It 'removes empty lines'
            result() { printf '\n\n\ncontent\n\n\n' | sed '/^[[:space:]]*$/d'; }
            When call result
            The output should include 'content'
            The lines of output should equal 1
        End
        
        It 'removes lines with only whitespace'
            result() { printf '   \n\t\n\ncontent\n   \n' | sed '/^[[:space:]]*$/d'; }
            When call result
            The output should include 'content'
            The lines of output should equal 1
        End
    End
    
    Describe 'Complete transformation pipeline'
        It 'applies all transformations correctly'
            result() {
                SampleHTML | 
                sed -n '/^<body>/q; p' |
                sed 's/ id=[^>]*>/>/g' |
                sed 's/ class=[^>]*>/>/g' |
                sed 's/ href=[^>]*>/>/g' |
                sed 's/ role=[^>]*>/>/g' |
                sed 's/ style=[^>]*>/>/g' |
                sed 's/ src=[^>]*>/>/g' |
                sed 's/strong>/b>/g' |
                sed 's/em>/i>/g' |
                sed 's/<div>\b.<\/div>//g' |
                sed 's/<div>[[:space:]]*<\/div>//g' |
                sed ':a; s/<a><sup[^>]*>[^<]*<\/sup><\/a>//g; ta' |
                sed '/^[[:space:]]*$/d'
            }
            When call result
            The output should include "<head>"
            The output should not include "<body>"
            The output should not include "id="
            The output should not include "class="
            The output should not include "href="
            The output should not include "role="
            The output should not include "style="
            The output should not include "src="
            The output should not include "strong>"
            The output should not include "em>"
            # Check that there are no empty lines
            The output should not match pattern '^[[:space:]]*$'
        End
    End
End