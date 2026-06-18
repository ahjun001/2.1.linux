# ,kClean_html_spec.sh
# ShellSpec unit tests for individual sed transformations

Describe ',kClean_html.sh sed transformations'
    
    Describe 'Body content extraction'
        It 'extracts content between <body> and </body> tags'
            result() {
                printf '%s\n' '<!DOCTYPE html>' \
                    '<html>' \
                    '<head>' \
                    '    <title>Test</title>' \
                    '</head>' \
                    '<body>' \
                    '    <h1>Welcome</h1>' \
                    '    <p>Content</p>' \
                    '</body>' \
                    '</html>' |
                sed -n '/<body>/,/<\/body>/p' |
                sed '1s/.*<body>//; $s/<\/body>.*//'
            }
            When call result
            The output should include "<h1>Welcome</h1>"
            The output should include "<p>Content</p>"
            The output should not include "<head>"
            The output should not include "<body>"
        End
    End
    
    Describe 'Attribute removal'
        Describe 'sed "s/ id=\"[^\"]*\"//g"'
            It 'removes id attributes with double quotes'
                result() {
                    echo '<div id="main" class="test">content</div>' | 
                    sed 's/ id="[^"]*"//g'
                }
                When call result
                The output should equal '<div class="test">content</div>'
                The output should not include 'id='
            End
            
            It 'removes id attributes with single quotes'
                result() {
                    echo "<div id='main' class='test'>content</div>" | 
                    sed "s/ id='[^']*'//g"
                }
                When call result
                The output should equal "<div class='test'>content</div>"
                The output should not include 'id='
            End
        End
        
        Describe 'sed "s/ class=\"[^\"]*\"//g"'
            It 'removes class attributes with double quotes'
                result() {
                    echo '<div id="main" class="container" role="main">content</div>' | 
                    sed 's/ class="[^"]*"//g'
                }
                When call result
                The output should equal '<div id="main" role="main">content</div>'
                The output should not include 'class='
            End
            
            It 'removes class attributes with single quotes'
                result() {
                    echo "<div id='main' class='container' role='main'>content</div>" | 
                    sed "s/ class='[^']*'//g"
                }
                When call result
                The output should equal "<div id='main' role='main'>content</div>"
                The output should not include 'class='
            End
        End
        
        Describe 'sed "s/ href=\"[^\"]*\"//g"'
            It 'removes href attributes with double quotes'
                result() {
                    echo '<a href="https://example.com" id="link">Link</a>' | 
                    sed 's/ href="[^"]*"//g'
                }
                When call result
                The output should equal '<a id="link">Link</a>'
                The output should not include 'href='
            End
            
            It 'removes href attributes with single quotes'
                result() {
                    echo "<a href='https://example.com' id='link'>Link</a>" | 
                    sed "s/ href='[^']*'//g"
                }
                When call result
                The output should equal "<a id='link'>Link</a>"
                The output should not include 'href='
            End
        End
        
        Describe 'sed "s/ role=\"[^\"]*\"//g"'
            It 'removes role attributes'
                result() {
                    echo '<div id="main" class="container" role="main">content</div>' | 
                    sed 's/ role="[^"]*"//g'
                }
                When call result
                The output should equal '<div id="main" class="container">content</div>'
                The output should not include 'role='
            End
        End
        
        Describe 'sed "s/ style=\"[^\"]*\"//g"'
            It 'removes style attributes'
                result() {
                    echo '<div style="color:red;font-size:16px;" class="test">content</div>' | 
                    sed 's/ style="[^"]*"//g'
                }
                When call result
                The output should equal '<div class="test">content</div>'
                The output should not include 'style='
            End
        End
        
        Describe 'sed "s/ src=\"[^\"]*\"//g"'
            It 'removes src attributes'
                result() {
                    echo '<img src="image.jpg" alt="image" class="test">' | 
                    sed 's/ src="[^"]*"//g'
                }
                When call result
                The output should equal '<img alt="image" class="test">'
                The output should not include 'src='
            End
        End
    End
    
    Describe 'Tag conversions'
        Describe 'sed "s/strong>/b>/g"'
            It 'converts strong tags to b tags'
                result() {
                    echo '<strong>Bold text</strong>' | 
                    sed 's/strong>/b>/g'
                }
                When call result
                The output should equal '<b>Bold text</b>'
                The output should not include 'strong>'
            End
        End
        
        Describe 'sed "s/em>/i>/g"'
            It 'converts em tags to i tags'
                result() {
                    echo '<em>Italic text</em>' | 
                    sed 's/em>/i>/g'
                }
                When call result
                The output should equal '<i>Italic text</i>'
                The output should not include 'em>'
            End
        End
    End
    
    Describe 'Div tag cleanup'
        Describe 'sed "s/<div>[[:space:]]*.[[:space:]]*<\/div>//g"'
            It 'removes div tags with single character content'
                result() {
                    echo '<div>A</div>' | 
                    sed 's/<div>[[:space:]]*.[[:space:]]*<\/div>//g'
                }
                When call result
                The output should be blank
            End
            
            It 'does not remove div tags with longer content'
                result() {
                    echo '<div>ABC</div>' | 
                    sed 's/<div>[[:space:]]*.[[:space:]]*<\/div>//g'
                }
                When call result
                The output should equal '<div>ABC</div>'
            End
        End
        
        Describe 'sed "s/<div>[[:space:]]*<\/div>//g"'
            It 'removes empty div tags'
                result() {
                    echo '<div></div>' | 
                    sed 's/<div>[[:space:]]*<\/div>//g'
                }
                When call result
                The output should be blank
            End
            
            It 'removes div tags with only whitespace'
                result() {
                    echo '<div> </div>' | 
                    sed 's/<div>[[:space:]]*<\/div>//g'
                }
                When call result
                The output should be blank
            End
        End
    End
    
    Describe 'Anchor-sup removal'
        Describe 'sed ":a; s/<a><sup[^>]*>[^<]*<\/sup><\/a>//g; ta"'
            It 'removes anchor tags containing sup tags'
                result() {
                    echo '<a><sup>1</sup></a>' | 
                    sed ':a; s/<a><sup[^>]*>[^<]*<\/sup><\/a>//g; ta'
                }
                When call result
                The output should be blank
            End
            
            It 'removes multiple anchor-sup combinations'
                result() {
                    echo '<a><sup>1</sup></a> <a><sup>2</sup></a>' | 
                    sed ':a; s/<a><sup[^>]*>[^<]*<\/sup><\/a>//g; ta'
                }
                When call result
                The output should equal ' '
            End
        End
    End
    
    Describe 'Whitespace cleanup'
        Describe 'sed "/^[[:space:]]*$/d"'
            It 'removes empty lines'
                result() {
                    printf '\n\n\ncontent\n\n\n' | 
                    sed '/^[[:space:]]*$/d'
                }
                When call result
                The output should include 'content'
                The lines of output should equal 1
            End
            
            It 'removes lines with only whitespace'
                result() {
                    printf '   \n\t\n\ncontent\n   \n' | 
                    sed '/^[[:space:]]*$/d'
                }
                When call result
                The output should include 'content'
                The lines of output should equal 1
            End
        End
    End
End