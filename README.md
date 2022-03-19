# 🐞 Bug Extract 🐞



# Build
` nimble --threads:on -d:ssl  build `

# Usage
 ` waybackurl victom.com | grep ".js$ " | ./Bugextract `


# Screenshoot



<img src="https://raw.githubusercontent.com/d0rksh/bugextract/main/carbon.png" width="70%" height="500">

# Pattern creation

Add your regex pattern to patterns.json file

```
[
        {
            "display":"single number",
            "regex":"^([0-10])",
            "pattern_type":"regex"
        },    
]
```
