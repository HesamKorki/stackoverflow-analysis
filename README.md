# stackoverflow-analysis
Exploring the StackOverflow Developer Survey 2023 dataset

<blockquote class="blockquote">
<p>There is a renv.lock file provided in the repo, we’d install the required packages and then laod the library</p>
</blockquote>
<div class="cell">
<div class="sourceCode cell-code" id="cb1"><pre class="sourceCode r code-with-copy"><code class="sourceCode r"><span id="cb1-1"><a href="#cb1-1" aria-hidden="true" tabindex="-1"></a><span class="fu">library</span>(<span class="st">"tidyverse"</span>)</span></code><button title="Copy to Clipboard" class="code-copy-button"><i class="bi"></i></button></pre></div>
<div class="cell-output cell-output-stderr">
<pre><code>── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
✔ dplyr     1.1.3     ✔ readr     2.1.4
✔ forcats   1.0.0     ✔ stringr   1.5.0
✔ ggplot2   3.4.3     ✔ tibble    3.2.1
✔ lubridate 1.9.2     ✔ tidyr     1.3.0
✔ purrr     1.0.2     
── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
✖ dplyr::filter() masks stats::filter()
✖ dplyr::lag()    masks stats::lag()
ℹ Use the conflicted package (&lt;http://conflicted.r-lib.org/&gt;) to force all conflicts to become errors</code></pre>
</div>
<div class="sourceCode cell-code" id="cb3"><pre class="sourceCode r code-with-copy"><code class="sourceCode r"><span id="cb3-1"><a href="#cb3-1" aria-hidden="true" tabindex="-1"></a><span class="fu">library</span>(<span class="st">"eurostat"</span>)</span>
<span id="cb3-2"><a href="#cb3-2" aria-hidden="true" tabindex="-1"></a><span class="fu">library</span>(<span class="st">"countrycode"</span>)</span>
<span id="cb3-3"><a href="#cb3-3" aria-hidden="true" tabindex="-1"></a><span class="fu">library</span>(<span class="st">"RColorBrewer"</span>)</span>
<span id="cb3-4"><a href="#cb3-4" aria-hidden="true" tabindex="-1"></a><span class="fu">library</span>(<span class="st">"ggbeeswarm"</span>)</span></code><button title="Copy to Clipboard" class="code-copy-button"><i class="bi"></i></button></pre></div>
</div>
<section id="loading-data" class="level1">
<h1>Loading Data</h1>
<div class="cell">
<div class="sourceCode cell-code" id="cb4"><pre class="sourceCode r code-with-copy"><code class="sourceCode r"><span id="cb4-1"><a href="#cb4-1" aria-hidden="true" tabindex="-1"></a>data <span class="ot">&lt;-</span> <span class="fu">read_csv</span>(<span class="st">"data/survey_results_public.csv"</span>, <span class="at">show_col_types =</span> <span class="cn">FALSE</span>)</span>
<span id="cb4-2"><a href="#cb4-2" aria-hidden="true" tabindex="-1"></a>eu_wage <span class="ot">&lt;-</span> <span class="fu">read_tsv</span>(<span class="st">"data/earn_mw_cur_tabular.tsv"</span>, <span class="at">show_col_types=</span><span class="cn">FALSE</span>)</span></code><button title="Copy to Clipboard" class="code-copy-button"><i class="bi"></i></button></pre></div>
</div>
<section id="configuring-plotting" class="level2">
<h2 class="anchored" data-anchor-id="configuring-plotting">Configuring Plotting</h2>
<div class="cell">
<div class="sourceCode cell-code" id="cb5"><pre class="sourceCode r code-with-copy"><code class="sourceCode r"><span id="cb5-1"><a href="#cb5-1" aria-hidden="true" tabindex="-1"></a><span class="co"># defining a theme for adjusting spacings of graphs</span></span>
<span id="cb5-2"><a href="#cb5-2" aria-hidden="true" tabindex="-1"></a>adjust_spacing <span class="ot">&lt;-</span></span>
<span id="cb5-3"><a href="#cb5-3" aria-hidden="true" tabindex="-1"></a>  <span class="fu">theme</span>(</span>
<span id="cb5-4"><a href="#cb5-4" aria-hidden="true" tabindex="-1"></a>    <span class="at">plot.title =</span> <span class="fu">element_text</span>(<span class="at">hjust =</span> <span class="fl">0.5</span>, <span class="at">margin =</span> <span class="fu">margin</span>(<span class="at">b =</span> <span class="dv">20</span>)),</span>
<span id="cb5-5"><a href="#cb5-5" aria-hidden="true" tabindex="-1"></a>    <span class="at">plot.margin =</span> <span class="fu">margin</span>(<span class="at">t=</span><span class="dv">20</span>, <span class="at">r=</span><span class="dv">50</span>, <span class="at">b=</span><span class="dv">20</span>, <span class="at">l=</span><span class="dv">20</span>, <span class="at">unit =</span> <span class="st">"pt"</span>)</span>
<span id="cb5-6"><a href="#cb5-6" aria-hidden="true" tabindex="-1"></a>  )</span>
<span id="cb5-7"><a href="#cb5-7" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb5-8"><a href="#cb5-8" aria-hidden="true" tabindex="-1"></a>primary_color <span class="ot">&lt;-</span> <span class="st">"#BDBAD7"</span></span>
<span id="cb5-9"><a href="#cb5-9" aria-hidden="true" tabindex="-1"></a>secondary_color <span class="ot">&lt;-</span> <span class="st">"#D2EAC9"</span></span></code><button title="Copy to Clipboard" class="code-copy-button"><i class="bi"></i></button></pre></div>
</div>
</section>
</section>
<section id="exploration" class="level1">
<h1>Exploration</h1>
<div class="callout callout-style-simple callout-note no-icon">
<div class="callout-body d-flex">
<div class="callout-icon-container">
<i class="callout-icon no-icon"></i>
</div>
<div class="callout-body-container">
<p>There are <span class="math inline">\(89,184\)</span> rows and <span class="math inline">\(84\)</span> columns</p>
<ul>
<li>Each row represents the answers of a participant</li>
<li>Each column corresponds to a question of the survey</li>
</ul>
</div>
</div>
</div>
<div class="cell">
<div class="sourceCode cell-code" id="cb6"><pre class="sourceCode r code-with-copy"><code class="sourceCode r"><span id="cb6-1"><a href="#cb6-1" aria-hidden="true" tabindex="-1"></a><span class="fu">glimpse</span>(data)</span></code><button title="Copy to Clipboard" class="code-copy-button"><i class="bi"></i></button></pre></div>
<div class="cell-output cell-output-stdout">
<pre><code>Rows: 89,184
Columns: 84
$ ResponseId                            &lt;dbl&gt; 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 1…
$ Q120                                  &lt;chr&gt; "I agree", "I agree", "I agree",…
$ MainBranch                            &lt;chr&gt; "None of these", "I am a develop…
$ Age                                   &lt;chr&gt; "18-24 years old", "25-34 years …
$ Employment                            &lt;chr&gt; NA, "Employed, full-time", "Empl…
$ RemoteWork                            &lt;chr&gt; NA, "Remote", "Hybrid (some remo…
$ CodingActivities                      &lt;chr&gt; NA, "Hobby;Contribute to open-so…
$ EdLevel                               &lt;chr&gt; NA, "Bachelor’s degree (B.A., B.…
$ LearnCode                             &lt;chr&gt; NA, "Books / Physical media;Coll…
$ LearnCodeOnline                       &lt;chr&gt; NA, "Formal documentation provid…
$ LearnCodeCoursesCert                  &lt;chr&gt; NA, "Other", NA, NA, "Other;Code…
$ YearsCode                             &lt;chr&gt; NA, "18", "27", "12", "6", "21",…
$ YearsCodePro                          &lt;chr&gt; NA, "9", "23", "7", "4", "21", "…
$ DevType                               &lt;chr&gt; NA, "Senior Executive (C-Suite, …
$ OrgSize                               &lt;chr&gt; NA, "2 to 9 employees", "5,000 t…
$ PurchaseInfluence                     &lt;chr&gt; NA, "I have a great deal of infl…
$ TechList                              &lt;chr&gt; NA, "Investigate", "Given a list…
$ BuyNewTool                            &lt;chr&gt; NA, "Start a free trial;Ask deve…
$ Country                               &lt;chr&gt; NA, "United States of America", …
$ Currency                              &lt;chr&gt; NA, "USD\tUnited States dollar",…
$ CompTotal                             &lt;dbl&gt; NA, 285000, 250000, 156000, 1320…
$ LanguageHaveWorkedWith                &lt;chr&gt; NA, "HTML/CSS;JavaScript;Python"…
$ LanguageWantToWorkWith                &lt;chr&gt; NA, "Bash/Shell (all shells);C#;…
$ DatabaseHaveWorkedWith                &lt;chr&gt; NA, "Supabase", NA, "PostgreSQL;…
$ DatabaseWantToWorkWith                &lt;chr&gt; NA, "Firebase Realtime Database;…
$ PlatformHaveWorkedWith                &lt;chr&gt; NA, "Amazon Web Services (AWS);N…
$ PlatformWantToWorkWith                &lt;chr&gt; NA, "Fly.io;Netlify;Render", NA,…
$ WebframeHaveWorkedWith                &lt;chr&gt; NA, "Next.js;React;Remix;Vue.js"…
$ WebframeWantToWorkWith                &lt;chr&gt; NA, "Deno;Elm;Nuxt.js;React;Svel…
$ MiscTechHaveWorkedWith                &lt;chr&gt; NA, "Electron;React Native;Tauri…
$ MiscTechWantToWorkWith                &lt;chr&gt; NA, "Capacitor;Electron;Tauri;Un…
$ ToolsTechHaveWorkedWith               &lt;chr&gt; NA, "Docker;Kubernetes;npm;Pip;V…
$ ToolsTechWantToWorkWith               &lt;chr&gt; NA, "Godot;npm;pnpm;Unity 3D;Unr…
$ NEWCollabToolsHaveWorkedWith          &lt;chr&gt; NA, "Vim;Visual Studio Code", "E…
$ NEWCollabToolsWantToWorkWith          &lt;chr&gt; NA, "Vim;Visual Studio Code", "E…
$ `OpSysPersonal use`                   &lt;chr&gt; NA, "iOS;iPadOS;MacOS;Windows;Wi…
$ `OpSysProfessional use`               &lt;chr&gt; NA, "MacOS;Windows;Windows Subsy…
$ OfficeStackAsyncHaveWorkedWith        &lt;chr&gt; NA, "Asana;Basecamp;GitHub Discu…
$ OfficeStackAsyncWantToWorkWith        &lt;chr&gt; NA, "GitHub Discussions;Linear;N…
$ OfficeStackSyncHaveWorkedWith         &lt;chr&gt; NA, "Cisco Webex Teams;Discord;G…
$ OfficeStackSyncWantToWorkWith         &lt;chr&gt; NA, "Discord;Signal;Slack;Zoom",…
$ AISearchHaveWorkedWith                &lt;chr&gt; NA, "ChatGPT", NA, NA, "ChatGPT"…
$ AISearchWantToWorkWith                &lt;chr&gt; NA, "ChatGPT;Neeva AI", NA, NA, …
$ AIDevHaveWorkedWith                   &lt;chr&gt; NA, "GitHub Copilot", NA, NA, NA…
$ AIDevWantToWorkWith                   &lt;chr&gt; NA, "GitHub Copilot", NA, NA, NA…
$ NEWSOSites                            &lt;chr&gt; NA, "Stack Overflow;Stack Exchan…
$ SOVisitFreq                           &lt;chr&gt; NA, "Daily or almost daily", "A …
$ SOAccount                             &lt;chr&gt; NA, "Yes", "Yes", "Yes", "No", "…
$ SOPartFreq                            &lt;chr&gt; NA, "A few times per month or we…
$ SOComm                                &lt;chr&gt; NA, "Yes, definitely", "Neutral"…
$ SOAI                                  &lt;chr&gt; NA, "I don't think it's super ne…
$ AISelect                              &lt;chr&gt; NA, "Yes", "No, and I don't plan…
$ AISent                                &lt;chr&gt; NA, "Indifferent", NA, NA, "Very…
$ AIAcc                                 &lt;chr&gt; NA, "Other (please explain)", NA…
$ AIBen                                 &lt;chr&gt; NA, "Somewhat distrust", NA, NA,…
$ `AIToolInterested in Using`           &lt;chr&gt; NA, "Learning about a codebase;W…
$ `AIToolCurrently Using`               &lt;chr&gt; NA, "Writing code;Committing and…
$ `AIToolNot interested in Using`       &lt;chr&gt; NA, NA, NA, NA, NA, "Project pla…
$ `AINextVery different`                &lt;chr&gt; NA, NA, NA, NA, NA, NA, NA, NA, …
$ `AINextNeither different nor similar` &lt;chr&gt; NA, NA, NA, NA, NA, NA, NA, NA, …
$ `AINextSomewhat similar`              &lt;chr&gt; NA, NA, NA, NA, NA, NA, NA, NA, …
$ `AINextVery similar`                  &lt;chr&gt; NA, NA, NA, NA, NA, NA, NA, NA, …
$ `AINextSomewhat different`            &lt;chr&gt; NA, NA, NA, NA, NA, NA, NA, NA, …
$ TBranch                               &lt;chr&gt; NA, "Yes", "Yes", "Yes", "Yes", …
$ ICorPM                                &lt;chr&gt; NA, "People manager", "Individua…
$ WorkExp                               &lt;dbl&gt; NA, 10, 23, 7, 6, 22, 4, 5, NA, …
$ Knowledge_1                           &lt;chr&gt; NA, "Strongly agree", "Strongly …
$ Knowledge_2                           &lt;chr&gt; NA, "Agree", "Neither agree nor …
$ Knowledge_3                           &lt;chr&gt; NA, "Strongly agree", "Agree", "…
$ Knowledge_4                           &lt;chr&gt; NA, "Agree", "Agree", "Strongly …
$ Knowledge_5                           &lt;chr&gt; NA, "Agree", "Agree", "Agree", "…
$ Knowledge_6                           &lt;chr&gt; NA, "Agree", "Agree", "Neither a…
$ Knowledge_7                           &lt;chr&gt; NA, "Agree", "Agree", "Agree", "…
$ Knowledge_8                           &lt;chr&gt; NA, "Strongly agree", "Agree", "…
$ Frequency_1                           &lt;chr&gt; NA, "1-2 times a week", "6-10 ti…
$ Frequency_2                           &lt;chr&gt; NA, "10+ times a week", "6-10 ti…
$ Frequency_3                           &lt;chr&gt; NA, "Never", "3-5 times a week",…
$ TimeSearching                         &lt;chr&gt; NA, "15-30 minutes a day", "30-6…
$ TimeAnswering                         &lt;chr&gt; NA, "15-30 minutes a day", "30-6…
$ ProfessionalTech                      &lt;chr&gt; NA, "DevOps function;Microservic…
$ Industry                              &lt;chr&gt; NA, "Information Services, IT, S…
$ SurveyLength                          &lt;chr&gt; NA, "Appropriate in length", "Ap…
$ SurveyEase                            &lt;chr&gt; NA, "Easy", "Easy", "Easy", "Nei…
$ ConvertedCompYearly                   &lt;dbl&gt; NA, 285000, 250000, 156000, 2345…</code></pre>
</div>
</div>
<div class="callout callout-style-simple callout-warning no-icon">
<div class="callout-body d-flex">
<div class="callout-icon-container">
<i class="callout-icon no-icon"></i>
</div>
<div class="callout-body-container">
<p>Most columns have values as a single string which contains semicolon separated values which is not as tidy as we would want.</p>
</div>
</div>
</div>
<p>What interesting insights do you get by looking at this graph?</p>
<div class="cell">
<div class="sourceCode cell-code" id="cb8"><pre class="sourceCode r code-with-copy"><code class="sourceCode r"><span id="cb8-1"><a href="#cb8-1" aria-hidden="true" tabindex="-1"></a>level_order <span class="ot">=</span> <span class="fu">c</span>(</span>
<span id="cb8-2"><a href="#cb8-2" aria-hidden="true" tabindex="-1"></a>                <span class="st">"Prefer not to say"</span>,</span>
<span id="cb8-3"><a href="#cb8-3" aria-hidden="true" tabindex="-1"></a>                <span class="st">"65 years or older"</span>,</span>
<span id="cb8-4"><a href="#cb8-4" aria-hidden="true" tabindex="-1"></a>                <span class="st">"55-64 years old"</span>,</span>
<span id="cb8-5"><a href="#cb8-5" aria-hidden="true" tabindex="-1"></a>                <span class="st">"45-54 years old"</span>,</span>
<span id="cb8-6"><a href="#cb8-6" aria-hidden="true" tabindex="-1"></a>                <span class="st">"35-44 years old"</span>,</span>
<span id="cb8-7"><a href="#cb8-7" aria-hidden="true" tabindex="-1"></a>                <span class="st">"25-34 years old"</span>,</span>
<span id="cb8-8"><a href="#cb8-8" aria-hidden="true" tabindex="-1"></a>                <span class="st">"18-24 years old"</span>,</span>
<span id="cb8-9"><a href="#cb8-9" aria-hidden="true" tabindex="-1"></a>                <span class="st">"Under 18 years old"</span></span>
<span id="cb8-10"><a href="#cb8-10" aria-hidden="true" tabindex="-1"></a>                )</span>
<span id="cb8-11"><a href="#cb8-11" aria-hidden="true" tabindex="-1"></a>data <span class="sc">|&gt;</span></span>
<span id="cb8-12"><a href="#cb8-12" aria-hidden="true" tabindex="-1"></a>  <span class="fu">ggplot</span>() <span class="sc">+</span></span>
<span id="cb8-13"><a href="#cb8-13" aria-hidden="true" tabindex="-1"></a>  <span class="fu">aes</span>(<span class="at">y =</span> <span class="fu">factor</span>(Age, <span class="at">levels =</span> level_order)) <span class="sc">+</span></span>
<span id="cb8-14"><a href="#cb8-14" aria-hidden="true" tabindex="-1"></a>  <span class="fu">geom_bar</span>(<span class="at">fill =</span> primary_color, <span class="at">alpha =</span> <span class="fl">0.8</span>) <span class="sc">+</span></span>
<span id="cb8-15"><a href="#cb8-15" aria-hidden="true" tabindex="-1"></a>  <span class="fu">geom_text</span>(</span>
<span id="cb8-16"><a href="#cb8-16" aria-hidden="true" tabindex="-1"></a>    <span class="fu">aes</span>(<span class="at">label =</span> scales<span class="sc">::</span><span class="fu">percent</span>(<span class="fu">after_stat</span>(count)<span class="sc">/</span><span class="fu">sum</span>(count))),</span>
<span id="cb8-17"><a href="#cb8-17" aria-hidden="true" tabindex="-1"></a>    <span class="at">stat =</span> <span class="st">"count"</span>,</span>
<span id="cb8-18"><a href="#cb8-18" aria-hidden="true" tabindex="-1"></a>    <span class="at">hjust =</span> <span class="sc">-</span><span class="fl">0.2</span>,</span>
<span id="cb8-19"><a href="#cb8-19" aria-hidden="true" tabindex="-1"></a>    <span class="at">size =</span> <span class="dv">3</span>,</span>
<span id="cb8-20"><a href="#cb8-20" aria-hidden="true" tabindex="-1"></a>    <span class="at">color =</span> <span class="st">"black"</span></span>
<span id="cb8-21"><a href="#cb8-21" aria-hidden="true" tabindex="-1"></a>  ) <span class="sc">+</span></span>
<span id="cb8-22"><a href="#cb8-22" aria-hidden="true" tabindex="-1"></a>  <span class="fu">labs</span>(<span class="at">x =</span> <span class="cn">NULL</span>, <span class="at">y =</span> <span class="cn">NULL</span>, <span class="at">title =</span> <span class="st">"How old are the participants?"</span>) <span class="sc">+</span></span>
<span id="cb8-23"><a href="#cb8-23" aria-hidden="true" tabindex="-1"></a>  <span class="fu">annotate</span>(</span>
<span id="cb8-24"><a href="#cb8-24" aria-hidden="true" tabindex="-1"></a>    <span class="st">"label"</span>,</span>
<span id="cb8-25"><a href="#cb8-25" aria-hidden="true" tabindex="-1"></a>    <span class="at">x =</span> <span class="dv">40000</span>, <span class="at">y =</span> <span class="fl">1.5</span>,</span>
<span id="cb8-26"><a href="#cb8-26" aria-hidden="true" tabindex="-1"></a>    <span class="at">label =</span> <span class="fu">paste</span>(<span class="st">"Total Number of Participents:"</span>, scales<span class="sc">::</span><span class="fu">comma</span>(<span class="fu">nrow</span>(data))),</span>
<span id="cb8-27"><a href="#cb8-27" aria-hidden="true" tabindex="-1"></a>    <span class="at">color =</span> <span class="st">"black"</span>,</span>
<span id="cb8-28"><a href="#cb8-28" aria-hidden="true" tabindex="-1"></a>    <span class="at">size=</span><span class="dv">3</span></span>
<span id="cb8-29"><a href="#cb8-29" aria-hidden="true" tabindex="-1"></a>  ) <span class="sc">+</span></span>
<span id="cb8-30"><a href="#cb8-30" aria-hidden="true" tabindex="-1"></a>  <span class="fu">theme_minimal</span>() <span class="sc">+</span></span>
<span id="cb8-31"><a href="#cb8-31" aria-hidden="true" tabindex="-1"></a>  <span class="fu">scale_x_continuous</span>(<span class="at">labels =</span> scales<span class="sc">::</span>comma, <span class="at">limits =</span> <span class="fu">c</span>(<span class="dv">0</span>, <span class="dv">50000</span>)) <span class="sc">+</span></span>
<span id="cb8-32"><a href="#cb8-32" aria-hidden="true" tabindex="-1"></a>  adjust_spacing </span></code><button title="Copy to Clipboard" class="code-copy-button"><i class="bi"></i></button></pre></div>
<div class="cell-output-display">
<p><img src="analysis_files/figure-html/unnamed-chunk-5-1.png" class="img-fluid" width="672"></p>
</div>
</div>
<div class="cell">
<div class="sourceCode cell-code" id="cb9"><pre class="sourceCode r code-with-copy"><code class="sourceCode r"><span id="cb9-1"><a href="#cb9-1" aria-hidden="true" tabindex="-1"></a>employment_df <span class="ot">&lt;-</span> data <span class="sc">|&gt;</span> </span>
<span id="cb9-2"><a href="#cb9-2" aria-hidden="true" tabindex="-1"></a>  <span class="fu">select</span>(ResponseId, Employment, Currency, CompTotal, EdLevel, Age) <span class="sc">|&gt;</span> </span>
<span id="cb9-3"><a href="#cb9-3" aria-hidden="true" tabindex="-1"></a>  <span class="fu">separate_rows</span>(Employment, <span class="at">sep=</span><span class="st">";"</span>) <span class="sc">|&gt;</span> </span>
<span id="cb9-4"><a href="#cb9-4" aria-hidden="true" tabindex="-1"></a>  <span class="fu">mutate</span>(<span class="at">Employment=</span><span class="fu">trimws</span>(Employment)) <span class="sc">|&gt;</span></span>
<span id="cb9-5"><a href="#cb9-5" aria-hidden="true" tabindex="-1"></a>  <span class="fu">drop_na</span>(Employment)</span>
<span id="cb9-6"><a href="#cb9-6" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb9-7"><a href="#cb9-7" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb9-8"><a href="#cb9-8" aria-hidden="true" tabindex="-1"></a>employment_df <span class="sc">|&gt;</span></span>
<span id="cb9-9"><a href="#cb9-9" aria-hidden="true" tabindex="-1"></a>  <span class="fu">ggplot</span>() <span class="sc">+</span></span>
<span id="cb9-10"><a href="#cb9-10" aria-hidden="true" tabindex="-1"></a>  <span class="fu">aes</span>(<span class="at">y =</span> <span class="fu">fct_rev</span>(<span class="fu">fct_infreq</span>(Employment))) <span class="sc">+</span></span>
<span id="cb9-11"><a href="#cb9-11" aria-hidden="true" tabindex="-1"></a>  <span class="fu">geom_bar</span>(<span class="at">fill =</span> primary_color, <span class="at">alpha =</span> <span class="fl">0.8</span>) <span class="sc">+</span></span>
<span id="cb9-12"><a href="#cb9-12" aria-hidden="true" tabindex="-1"></a>  <span class="fu">geom_text</span>(</span>
<span id="cb9-13"><a href="#cb9-13" aria-hidden="true" tabindex="-1"></a>    <span class="fu">aes</span>(<span class="at">label =</span> scales<span class="sc">::</span><span class="fu">percent</span>(<span class="fu">after_stat</span>(count)<span class="sc">/</span><span class="fu">sum</span>(count))),</span>
<span id="cb9-14"><a href="#cb9-14" aria-hidden="true" tabindex="-1"></a>    <span class="at">stat =</span> <span class="st">"count"</span>,</span>
<span id="cb9-15"><a href="#cb9-15" aria-hidden="true" tabindex="-1"></a>    <span class="at">hjust =</span> <span class="sc">-</span><span class="fl">0.2</span>,</span>
<span id="cb9-16"><a href="#cb9-16" aria-hidden="true" tabindex="-1"></a>    <span class="at">size =</span> <span class="dv">3</span>,</span>
<span id="cb9-17"><a href="#cb9-17" aria-hidden="true" tabindex="-1"></a>    <span class="at">color =</span> <span class="st">"black"</span></span>
<span id="cb9-18"><a href="#cb9-18" aria-hidden="true" tabindex="-1"></a>  ) <span class="sc">+</span></span>
<span id="cb9-19"><a href="#cb9-19" aria-hidden="true" tabindex="-1"></a>  <span class="fu">labs</span>(<span class="at">x =</span> <span class="cn">NULL</span>, <span class="at">y =</span> <span class="cn">NULL</span>, <span class="at">title =</span> <span class="st">"Employment status of respondants"</span>) <span class="sc">+</span></span>
<span id="cb9-20"><a href="#cb9-20" aria-hidden="true" tabindex="-1"></a>  <span class="fu">theme_minimal</span>() <span class="sc">+</span></span>
<span id="cb9-21"><a href="#cb9-21" aria-hidden="true" tabindex="-1"></a>  adjust_spacing <span class="sc">+</span> </span>
<span id="cb9-22"><a href="#cb9-22" aria-hidden="true" tabindex="-1"></a>  <span class="fu">scale_x_continuous</span>(<span class="at">labels =</span> scales<span class="sc">::</span>comma, <span class="at">limits =</span> <span class="fu">c</span>(<span class="dv">0</span>, <span class="dv">70000</span>))</span></code><button title="Copy to Clipboard" class="code-copy-button"><i class="bi"></i></button></pre></div>
<div class="cell-output-display">
<p><img src="analysis_files/figure-html/unnamed-chunk-6-1.png" class="img-fluid" width="672"></p>
</div>
</div>
<div class="cell">
<div class="sourceCode cell-code" id="cb10"><pre class="sourceCode r code-with-copy"><code class="sourceCode r"><span id="cb10-1"><a href="#cb10-1" aria-hidden="true" tabindex="-1"></a>continent_data <span class="ot">&lt;-</span> data <span class="sc">|&gt;</span></span>
<span id="cb10-2"><a href="#cb10-2" aria-hidden="true" tabindex="-1"></a>  <span class="fu">mutate</span>(<span class="at">Continent =</span> <span class="fu">countrycode</span>(</span>
<span id="cb10-3"><a href="#cb10-3" aria-hidden="true" tabindex="-1"></a>    <span class="at">sourcevar =</span> Country,</span>
<span id="cb10-4"><a href="#cb10-4" aria-hidden="true" tabindex="-1"></a>    <span class="at">origin =</span> <span class="st">"country.name"</span>,</span>
<span id="cb10-5"><a href="#cb10-5" aria-hidden="true" tabindex="-1"></a>    <span class="at">destination =</span> <span class="st">"continent"</span></span>
<span id="cb10-6"><a href="#cb10-6" aria-hidden="true" tabindex="-1"></a>  )) <span class="sc">|&gt;</span></span>
<span id="cb10-7"><a href="#cb10-7" aria-hidden="true" tabindex="-1"></a>  <span class="fu">drop_na</span>(Continent) <span class="sc">|&gt;</span> </span>
<span id="cb10-8"><a href="#cb10-8" aria-hidden="true" tabindex="-1"></a>  <span class="fu">group_by</span>(Continent, Country) <span class="sc">|&gt;</span> </span>
<span id="cb10-9"><a href="#cb10-9" aria-hidden="true" tabindex="-1"></a>  <span class="fu">summarise</span>(<span class="at">freq=</span> <span class="fu">n</span>()) <span class="sc">|&gt;</span> </span>
<span id="cb10-10"><a href="#cb10-10" aria-hidden="true" tabindex="-1"></a>  <span class="fu">mutate</span>(</span>
<span id="cb10-11"><a href="#cb10-11" aria-hidden="true" tabindex="-1"></a>    <span class="at">Country =</span> <span class="fu">case_when</span>(</span>
<span id="cb10-12"><a href="#cb10-12" aria-hidden="true" tabindex="-1"></a>      Country <span class="sc">==</span> <span class="st">"United States of America"</span> <span class="sc">~</span> <span class="st">"USA"</span>,</span>
<span id="cb10-13"><a href="#cb10-13" aria-hidden="true" tabindex="-1"></a>      Country <span class="sc">==</span> <span class="st">"United Kingdom of Great Britain and Northern Ireland"</span> <span class="sc">~</span> <span class="st">"UK"</span>,</span>
<span id="cb10-14"><a href="#cb10-14" aria-hidden="true" tabindex="-1"></a>      <span class="cn">TRUE</span> <span class="sc">~</span> Country</span>
<span id="cb10-15"><a href="#cb10-15" aria-hidden="true" tabindex="-1"></a>    )</span>
<span id="cb10-16"><a href="#cb10-16" aria-hidden="true" tabindex="-1"></a>  )</span></code><button title="Copy to Clipboard" class="code-copy-button"><i class="bi"></i></button></pre></div>
<div class="cell-output cell-output-stderr">
<pre><code>Warning: There was 1 warning in `mutate()`.
ℹ In argument: `Continent = countrycode(sourcevar = Country, origin =
  "country.name", destination = "continent")`.
Caused by warning:
! Some values were not matched unambiguously: Kosovo, Nomadic</code></pre>
</div>
<div class="cell-output cell-output-stderr">
<pre><code>`summarise()` has grouped output by 'Continent'. You can override using the
`.groups` argument.</code></pre>
</div>
<div class="sourceCode cell-code" id="cb13"><pre class="sourceCode r code-with-copy"><code class="sourceCode r"><span id="cb13-1"><a href="#cb13-1" aria-hidden="true" tabindex="-1"></a>custom_brewer <span class="ot">&lt;-</span>  <span class="fu">brewer.pal</span>(<span class="dv">11</span>, <span class="st">"Set3"</span>)</span>
<span id="cb13-2"><a href="#cb13-2" aria-hidden="true" tabindex="-1"></a>custom_brewer[<span class="fu">c</span>(<span class="dv">9</span>,<span class="dv">11</span>)] <span class="ot">&lt;-</span> custom_brewer[<span class="fu">c</span>(<span class="dv">11</span>,<span class="dv">9</span>)]</span>
<span id="cb13-3"><a href="#cb13-3" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb13-4"><a href="#cb13-4" aria-hidden="true" tabindex="-1"></a>continent_data <span class="sc">|&gt;</span></span>
<span id="cb13-5"><a href="#cb13-5" aria-hidden="true" tabindex="-1"></a>  <span class="fu">ggplot</span>() <span class="sc">+</span></span>
<span id="cb13-6"><a href="#cb13-6" aria-hidden="true" tabindex="-1"></a>  <span class="fu">aes</span>(<span class="at">y =</span> Continent,</span>
<span id="cb13-7"><a href="#cb13-7" aria-hidden="true" tabindex="-1"></a>      <span class="at">x =</span> freq,</span>
<span id="cb13-8"><a href="#cb13-8" aria-hidden="true" tabindex="-1"></a>      <span class="at">fill =</span> <span class="fu">fct_lump</span>(Country, <span class="at">n=</span><span class="dv">10</span>, <span class="at">w=</span>freq)) <span class="sc">+</span></span>
<span id="cb13-9"><a href="#cb13-9" aria-hidden="true" tabindex="-1"></a>  <span class="fu">geom_col</span>() <span class="sc">+</span></span>
<span id="cb13-10"><a href="#cb13-10" aria-hidden="true" tabindex="-1"></a>  <span class="fu">labs</span>(<span class="at">title =</span> <span class="st">"Diversity of Respondants"</span>, <span class="at">x =</span> <span class="cn">NULL</span>, <span class="at">y =</span> <span class="cn">NULL</span>, <span class="at">fill=</span><span class="cn">NULL</span>) <span class="sc">+</span></span>
<span id="cb13-11"><a href="#cb13-11" aria-hidden="true" tabindex="-1"></a>  <span class="fu">scale_x_continuous</span>(<span class="at">labels =</span> scales<span class="sc">::</span>comma) <span class="sc">+</span></span>
<span id="cb13-12"><a href="#cb13-12" aria-hidden="true" tabindex="-1"></a>  <span class="fu">theme_minimal</span>()<span class="sc">+</span> </span>
<span id="cb13-13"><a href="#cb13-13" aria-hidden="true" tabindex="-1"></a>  <span class="fu">scale_fill_manual</span>(<span class="at">values=</span> custom_brewer) <span class="sc">+</span></span>
<span id="cb13-14"><a href="#cb13-14" aria-hidden="true" tabindex="-1"></a>  adjust_spacing</span></code><button title="Copy to Clipboard" class="code-copy-button"><i class="bi"></i></button></pre></div>
<div class="cell-output-display">
<p><img src="analysis_files/figure-html/unnamed-chunk-7-1.png" class="img-fluid" width="672"></p>
</div>
</div>
<div class="cell">
<div class="sourceCode cell-code" id="cb14"><pre class="sourceCode r code-with-copy"><code class="sourceCode r"><span id="cb14-1"><a href="#cb14-1" aria-hidden="true" tabindex="-1"></a>continent_data <span class="sc">|&gt;</span> </span>
<span id="cb14-2"><a href="#cb14-2" aria-hidden="true" tabindex="-1"></a>  <span class="fu">arrange</span>(<span class="fu">desc</span>(freq))</span></code><button title="Copy to Clipboard" class="code-copy-button"><i class="bi"></i></button></pre></div>
<div class="cell-output cell-output-stdout">
<pre><code># A tibble: 183 × 3
# Groups:   Continent [5]
   Continent Country      freq
   &lt;chr&gt;     &lt;chr&gt;       &lt;int&gt;
 1 Americas  USA         18647
 2 Europe    Germany      7328
 3 Asia      India        5625
 4 Europe    UK           5552
 5 Americas  Canada       3507
 6 Europe    France       2933
 7 Europe    Poland       2435
 8 Europe    Netherlands  2383
 9 Oceania   Australia    2078
10 Americas  Brazil       2042
# ℹ 173 more rows</code></pre>
</div>
</div>
<div class="cell">
<div class="sourceCode cell-code" id="cb16"><pre class="sourceCode r code-with-copy"><code class="sourceCode r"><span id="cb16-1"><a href="#cb16-1" aria-hidden="true" tabindex="-1"></a>eu <span class="ot">&lt;-</span> data <span class="sc">|&gt;</span> </span>
<span id="cb16-2"><a href="#cb16-2" aria-hidden="true" tabindex="-1"></a>  <span class="fu">filter</span>(Currency <span class="sc">==</span> <span class="st">"EUR European Euro"</span>) <span class="sc">|&gt;</span> </span>
<span id="cb16-3"><a href="#cb16-3" aria-hidden="true" tabindex="-1"></a>  <span class="fu">drop_na</span>(CompTotal)<span class="co"># |&gt; </span></span>
<span id="cb16-4"><a href="#cb16-4" aria-hidden="true" tabindex="-1"></a>  <span class="co"># filter(CompTotal&lt;500000)</span></span>
<span id="cb16-5"><a href="#cb16-5" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb16-6"><a href="#cb16-6" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb16-7"><a href="#cb16-7" aria-hidden="true" tabindex="-1"></a>eu <span class="sc">|&gt;</span></span>
<span id="cb16-8"><a href="#cb16-8" aria-hidden="true" tabindex="-1"></a>  <span class="fu">ggplot</span>(<span class="fu">aes</span>(<span class="at">x=</span>CompTotal)) <span class="sc">+</span></span>
<span id="cb16-9"><a href="#cb16-9" aria-hidden="true" tabindex="-1"></a>  <span class="fu">geom_histogram</span>(<span class="at">bins=</span><span class="dv">120</span>) <span class="sc">+</span></span>
<span id="cb16-10"><a href="#cb16-10" aria-hidden="true" tabindex="-1"></a>  <span class="fu">geom_vline</span>(<span class="fu">aes</span>(<span class="at">xintercept =</span> <span class="fu">median</span>(CompTotal)), <span class="at">color =</span> primary_color, <span class="at">linetype =</span> <span class="st">"dashed"</span>, <span class="at">size =</span> <span class="dv">1</span>) <span class="sc">+</span></span>
<span id="cb16-11"><a href="#cb16-11" aria-hidden="true" tabindex="-1"></a>  <span class="fu">geom_vline</span>(<span class="fu">aes</span>(<span class="at">xintercept =</span> <span class="fu">mean</span>(CompTotal)), <span class="at">color =</span> secondary_color, <span class="at">linetype =</span> <span class="st">"dashed"</span>, <span class="at">size =</span> <span class="dv">1</span>) <span class="sc">+</span></span>
<span id="cb16-12"><a href="#cb16-12" aria-hidden="true" tabindex="-1"></a>  <span class="fu">annotate</span>(</span>
<span id="cb16-13"><a href="#cb16-13" aria-hidden="true" tabindex="-1"></a>    <span class="st">"label"</span>,</span>
<span id="cb16-14"><a href="#cb16-14" aria-hidden="true" tabindex="-1"></a>    <span class="at">x =</span> <span class="dv">10</span>, <span class="at">y =</span> <span class="dv">1500</span>,</span>
<span id="cb16-15"><a href="#cb16-15" aria-hidden="true" tabindex="-1"></a>    <span class="at">label =</span> <span class="fu">paste</span>(<span class="st">"Medain:"</span>, scales<span class="sc">::</span><span class="fu">comma</span>(<span class="fu">median</span>(eu<span class="sc">$</span>CompTotal), <span class="at">suffix =</span> <span class="st">" \u20AC"</span>)),</span>
<span id="cb16-16"><a href="#cb16-16" aria-hidden="true" tabindex="-1"></a>    <span class="at">color =</span> primary_color,</span>
<span id="cb16-17"><a href="#cb16-17" aria-hidden="true" tabindex="-1"></a>    <span class="at">fill =</span> <span class="st">"black"</span>,</span>
<span id="cb16-18"><a href="#cb16-18" aria-hidden="true" tabindex="-1"></a>    <span class="at">size=</span><span class="dv">3</span></span>
<span id="cb16-19"><a href="#cb16-19" aria-hidden="true" tabindex="-1"></a>  ) <span class="sc">+</span></span>
<span id="cb16-20"><a href="#cb16-20" aria-hidden="true" tabindex="-1"></a>  <span class="fu">annotate</span>(</span>
<span id="cb16-21"><a href="#cb16-21" aria-hidden="true" tabindex="-1"></a>    <span class="st">"label"</span>,</span>
<span id="cb16-22"><a href="#cb16-22" aria-hidden="true" tabindex="-1"></a>    <span class="at">x =</span> <span class="dv">10</span>, <span class="at">y =</span> <span class="dv">1600</span>,</span>
<span id="cb16-23"><a href="#cb16-23" aria-hidden="true" tabindex="-1"></a>    <span class="at">label =</span> <span class="fu">paste</span>(<span class="st">"Mean:"</span>, scales<span class="sc">::</span><span class="fu">comma</span>(<span class="fu">mean</span>(eu<span class="sc">$</span>CompTotal), <span class="at">suffix =</span> <span class="st">" \u20AC"</span>)),</span>
<span id="cb16-24"><a href="#cb16-24" aria-hidden="true" tabindex="-1"></a>    <span class="at">color =</span> secondary_color,</span>
<span id="cb16-25"><a href="#cb16-25" aria-hidden="true" tabindex="-1"></a>    <span class="at">fill =</span> <span class="st">"black"</span>,</span>
<span id="cb16-26"><a href="#cb16-26" aria-hidden="true" tabindex="-1"></a>    <span class="at">size=</span><span class="fl">3.3</span></span>
<span id="cb16-27"><a href="#cb16-27" aria-hidden="true" tabindex="-1"></a>  ) <span class="sc">+</span></span>
<span id="cb16-28"><a href="#cb16-28" aria-hidden="true" tabindex="-1"></a>  <span class="fu">scale_x_log10</span>(<span class="at">labels =</span> scales<span class="sc">::</span><span class="fu">label_comma</span>(<span class="at">suffix =</span> <span class="st">" \u20AC"</span>)) <span class="sc">+</span></span>
<span id="cb16-29"><a href="#cb16-29" aria-hidden="true" tabindex="-1"></a>  <span class="fu">labs</span>(<span class="at">x=</span><span class="cn">NULL</span>, <span class="at">y=</span><span class="cn">NULL</span>, <span class="at">title=</span><span class="st">"Distribution of Gross Annual Income"</span>) <span class="sc">+</span></span>
<span id="cb16-30"><a href="#cb16-30" aria-hidden="true" tabindex="-1"></a>  adjust_spacing</span></code><button title="Copy to Clipboard" class="code-copy-button"><i class="bi"></i></button></pre></div>
<div class="cell-output cell-output-stderr">
<pre><code>Warning: Using `size` aesthetic for lines was deprecated in ggplot2 3.4.0.
ℹ Please use `linewidth` instead.</code></pre>
</div>
<div class="cell-output cell-output-stderr">
<pre><code>Warning: Transformation introduced infinite values in continuous x-axis</code></pre>
</div>
<div class="cell-output cell-output-stderr">
<pre><code>Warning: Removed 29 rows containing non-finite values (`stat_bin()`).</code></pre>
</div>
<div class="cell-output-display">
<p><img src="analysis_files/figure-html/unnamed-chunk-9-1.png" class="img-fluid" width="672"></p>
</div>
</div>
<div class="cell">
<div class="sourceCode cell-code" id="cb20"><pre class="sourceCode r code-with-copy"><code class="sourceCode r"><span id="cb20-1"><a href="#cb20-1" aria-hidden="true" tabindex="-1"></a>eu <span class="sc">|&gt;</span> </span>
<span id="cb20-2"><a href="#cb20-2" aria-hidden="true" tabindex="-1"></a>  <span class="fu">ggplot</span>() <span class="sc">+</span></span>
<span id="cb20-3"><a href="#cb20-3" aria-hidden="true" tabindex="-1"></a>  <span class="fu">aes</span>(<span class="at">x=</span><span class="fu">fct_lump</span>(Country, <span class="at">n=</span><span class="dv">10</span>, <span class="at">w=</span>CompTotal), <span class="at">y=</span>CompTotal) <span class="sc">+</span></span>
<span id="cb20-4"><a href="#cb20-4" aria-hidden="true" tabindex="-1"></a>  <span class="fu">geom_quasirandom</span>(<span class="at">dodge.width =</span> <span class="dv">1</span>, <span class="at">size=</span><span class="fl">0.1</span>, <span class="at">bandwidth=</span><span class="fl">0.8</span>, <span class="at">color=</span>custom_brewer[<span class="dv">5</span>]) <span class="sc">+</span> </span>
<span id="cb20-5"><a href="#cb20-5" aria-hidden="true" tabindex="-1"></a>  <span class="fu">scale_y_log10</span>(<span class="at">labels =</span> scales<span class="sc">::</span><span class="fu">label_comma</span>(<span class="at">suffix =</span> <span class="st">" \u20AC"</span>)) <span class="sc">+</span> </span>
<span id="cb20-6"><a href="#cb20-6" aria-hidden="true" tabindex="-1"></a>  <span class="fu">labs</span>(<span class="at">x=</span><span class="cn">NULL</span>, <span class="at">y=</span><span class="cn">NULL</span>, <span class="at">title=</span><span class="st">"EU Gross Salary Distribution by Country"</span>) <span class="sc">+</span></span>
<span id="cb20-7"><a href="#cb20-7" aria-hidden="true" tabindex="-1"></a>  <span class="fu">theme</span>(<span class="at">axis.text.x =</span> <span class="fu">element_text</span>(<span class="at">angle =</span> <span class="dv">30</span>, <span class="at">hjust =</span> <span class="dv">1</span>)) <span class="sc">+</span></span>
<span id="cb20-8"><a href="#cb20-8" aria-hidden="true" tabindex="-1"></a>  adjust_spacing</span></code><button title="Copy to Clipboard" class="code-copy-button"><i class="bi"></i></button></pre></div>
<div class="cell-output cell-output-stderr">
<pre><code>Warning: Transformation introduced infinite values in continuous y-axis</code></pre>
</div>
<div class="cell-output cell-output-stderr">
<pre><code>Warning: Removed 29 rows containing missing values (`geom_point()`).</code></pre>
</div>
<div class="cell-output-display">
<p><img src="analysis_files/figure-html/unnamed-chunk-10-1.png" class="img-fluid" width="672"></p>
</div>
</div>
<div class="cell">
<div class="sourceCode cell-code" id="cb23"><pre class="sourceCode r code-with-copy"><code class="sourceCode r"><span id="cb23-1"><a href="#cb23-1" aria-hidden="true" tabindex="-1"></a>eu_employment <span class="ot">&lt;-</span> </span>
<span id="cb23-2"><a href="#cb23-2" aria-hidden="true" tabindex="-1"></a>  employment_df <span class="sc">|&gt;</span> </span>
<span id="cb23-3"><a href="#cb23-3" aria-hidden="true" tabindex="-1"></a>    <span class="fu">filter</span>(Currency <span class="sc">==</span> <span class="st">"EUR European Euro"</span>) <span class="sc">|&gt;</span> </span>
<span id="cb23-4"><a href="#cb23-4" aria-hidden="true" tabindex="-1"></a>    <span class="fu">drop_na</span>(CompTotal) <span class="sc">|&gt;</span> </span>
<span id="cb23-5"><a href="#cb23-5" aria-hidden="true" tabindex="-1"></a>    <span class="fu">drop_na</span>(EdLevel)</span>
<span id="cb23-6"><a href="#cb23-6" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb23-7"><a href="#cb23-7" aria-hidden="true" tabindex="-1"></a>stat_emp <span class="ot">&lt;-</span> eu_employment <span class="sc">|&gt;</span> <span class="fu">summarise</span>(<span class="at">mean_emp=</span><span class="fu">mean</span>(CompTotal), <span class="at">.by=</span>Employment)</span>
<span id="cb23-8"><a href="#cb23-8" aria-hidden="true" tabindex="-1"></a>  </span>
<span id="cb23-9"><a href="#cb23-9" aria-hidden="true" tabindex="-1"></a>eu_employment <span class="sc">|&gt;</span> </span>
<span id="cb23-10"><a href="#cb23-10" aria-hidden="true" tabindex="-1"></a>  <span class="fu">ggplot</span>(<span class="fu">aes</span>(<span class="at">x=</span>Employment, <span class="at">y=</span>CompTotal)) <span class="sc">+</span></span>
<span id="cb23-11"><a href="#cb23-11" aria-hidden="true" tabindex="-1"></a>  <span class="fu">geom_quasirandom</span>(<span class="at">dodge.width =</span> <span class="dv">1</span>, <span class="at">size=</span><span class="fl">0.1</span>, <span class="at">bandwidth=</span><span class="fl">0.8</span>, <span class="at">color=</span>custom_brewer[<span class="dv">5</span>]) <span class="sc">+</span></span>
<span id="cb23-12"><a href="#cb23-12" aria-hidden="true" tabindex="-1"></a>  <span class="fu">geom_segment</span>(<span class="at">data=</span>stat_emp, <span class="fu">aes</span>(<span class="at">x =</span> <span class="fu">as.numeric</span>(<span class="fu">factor</span>(Employment)) <span class="sc">-</span> <span class="fl">0.3</span>, </span>
<span id="cb23-13"><a href="#cb23-13" aria-hidden="true" tabindex="-1"></a>                   <span class="at">xend =</span> <span class="fu">as.numeric</span>(<span class="fu">factor</span>(Employment)) <span class="sc">+</span> <span class="fl">0.3</span>,</span>
<span id="cb23-14"><a href="#cb23-14" aria-hidden="true" tabindex="-1"></a>                   <span class="at">y =</span> mean_emp, </span>
<span id="cb23-15"><a href="#cb23-15" aria-hidden="true" tabindex="-1"></a>                   <span class="at">yend =</span> mean_emp),</span>
<span id="cb23-16"><a href="#cb23-16" aria-hidden="true" tabindex="-1"></a>               <span class="at">color =</span> <span class="st">"red"</span>, <span class="at">linetype =</span> <span class="st">"dashed"</span>, <span class="at">size =</span> <span class="fl">0.4</span>) <span class="sc">+</span></span>
<span id="cb23-17"><a href="#cb23-17" aria-hidden="true" tabindex="-1"></a>  <span class="fu">scale_y_log10</span>(<span class="at">labels =</span> scales<span class="sc">::</span><span class="fu">label_comma</span>(<span class="at">suffix =</span> <span class="st">" \u20AC"</span>)) <span class="sc">+</span> </span>
<span id="cb23-18"><a href="#cb23-18" aria-hidden="true" tabindex="-1"></a>  <span class="fu">labs</span>(<span class="at">x=</span><span class="cn">NULL</span>, <span class="at">y=</span><span class="cn">NULL</span>, <span class="at">title=</span><span class="st">"EU Gross Salary Distribution by Employment Status"</span>) <span class="sc">+</span></span>
<span id="cb23-19"><a href="#cb23-19" aria-hidden="true" tabindex="-1"></a>  <span class="fu">theme</span>(<span class="at">axis.text.x =</span> <span class="fu">element_text</span>(<span class="at">angle =</span> <span class="dv">30</span>, <span class="at">hjust =</span> <span class="dv">1</span>)) <span class="sc">+</span></span>
<span id="cb23-20"><a href="#cb23-20" aria-hidden="true" tabindex="-1"></a>  adjust_spacing</span></code><button title="Copy to Clipboard" class="code-copy-button"><i class="bi"></i></button></pre></div>
<div class="cell-output cell-output-stderr">
<pre><code>Warning: Transformation introduced infinite values in continuous y-axis</code></pre>
</div>
<div class="cell-output cell-output-stderr">
<pre><code>Warning: Removed 32 rows containing missing values (`geom_point()`).</code></pre>
</div>
<div class="cell-output-display">
<p><img src="analysis_files/figure-html/unnamed-chunk-11-1.png" class="img-fluid" width="672"></p>
</div>
</div>
<section id="does-more-experience-shows-more-salary" class="level2">
<h2 class="anchored" data-anchor-id="does-more-experience-shows-more-salary">Does more experience shows more salary?</h2>
</section>
</section>

</main>
<!-- /main column -->
<script id="quarto-html-after-body" type="application/javascript">
window.document.addEventListener("DOMContentLoaded", function (event) {
  const toggleBodyColorMode = (bsSheetEl) => {
    const mode = bsSheetEl.getAttribute("data-mode");
    const bodyEl = window.document.querySelector("body");
    if (mode === "dark") {
      bodyEl.classList.add("quarto-dark");
      bodyEl.classList.remove("quarto-light");
    } else {
      bodyEl.classList.add("quarto-light");
      bodyEl.classList.remove("quarto-dark");
    }
  }
  const toggleBodyColorPrimary = () => {
    const bsSheetEl = window.document.querySelector("link#quarto-bootstrap");
    if (bsSheetEl) {
      toggleBodyColorMode(bsSheetEl);
    }
  }
  toggleBodyColorPrimary();  
  const icon = "";
  const anchorJS = new window.AnchorJS();
  anchorJS.options = {
    placement: 'right',
    icon: icon
  };
  anchorJS.add('.anchored');
  const isCodeAnnotation = (el) => {
    for (const clz of el.classList) {
      if (clz.startsWith('code-annotation-')) {                     
        return true;
      }
    }
    return false;
  }
  const clipboard = new window.ClipboardJS('.code-copy-button', {
    text: function(trigger) {
      const codeEl = trigger.previousElementSibling.cloneNode(true);
      for (const childEl of codeEl.children) {
        if (isCodeAnnotation(childEl)) {
          childEl.remove();
        }
      }
      return codeEl.innerText;
    }
  });
  clipboard.on('success', function(e) {
    // button target
    const button = e.trigger;
    // don't keep focus
    button.blur();
    // flash "checked"
    button.classList.add('code-copy-button-checked');
    var currentTitle = button.getAttribute("title");
    button.setAttribute("title", "Copied!");
    let tooltip;
    if (window.bootstrap) {
      button.setAttribute("data-bs-toggle", "tooltip");
      button.setAttribute("data-bs-placement", "left");
      button.setAttribute("data-bs-title", "Copied!");
      tooltip = new bootstrap.Tooltip(button, 
        { trigger: "manual", 
          customClass: "code-copy-button-tooltip",
          offset: [0, -8]});
      tooltip.show();    
    }
    setTimeout(function() {
      if (tooltip) {
        tooltip.hide();
        button.removeAttribute("data-bs-title");
        button.removeAttribute("data-bs-toggle");
        button.removeAttribute("data-bs-placement");
      }
      button.setAttribute("title", currentTitle);
      button.classList.remove('code-copy-button-checked');
    }, 1000);
    // clear code selection
    e.clearSelection();
  });
  function tippyHover(el, contentFn) {
    const config = {
      allowHTML: true,
      content: contentFn,
      maxWidth: 500,
      delay: 100,
      arrow: false,
      appendTo: function(el) {
          return el.parentElement;
      },
      interactive: true,
      interactiveBorder: 10,
      theme: 'quarto',
      placement: 'bottom-start'
    };
    window.tippy(el, config); 
  }
  const noterefs = window.document.querySelectorAll('a[role="doc-noteref"]');
  for (var i=0; i<noterefs.length; i++) {
    const ref = noterefs[i];
    tippyHover(ref, function() {
      // use id or data attribute instead here
      let href = ref.getAttribute('data-footnote-href') || ref.getAttribute('href');
      try { href = new URL(href).hash; } catch {}
      const id = href.replace(/^#\/?/, "");
      const note = window.document.getElementById(id);
      return note.innerHTML;
    });
  }
      let selectedAnnoteEl;
      const selectorForAnnotation = ( cell, annotation) => {
        let cellAttr = 'data-code-cell="' + cell + '"';
        let lineAttr = 'data-code-annotation="' +  annotation + '"';
        const selector = 'span[' + cellAttr + '][' + lineAttr + ']';
        return selector;
      }
      const selectCodeLines = (annoteEl) => {
        const doc = window.document;
        const targetCell = annoteEl.getAttribute("data-target-cell");
        const targetAnnotation = annoteEl.getAttribute("data-target-annotation");
        const annoteSpan = window.document.querySelector(selectorForAnnotation(targetCell, targetAnnotation));
        const lines = annoteSpan.getAttribute("data-code-lines").split(",");
        const lineIds = lines.map((line) => {
          return targetCell + "-" + line;
        })
        let top = null;
        let height = null;
        let parent = null;
        if (lineIds.length > 0) {
            //compute the position of the single el (top and bottom and make a div)
            const el = window.document.getElementById(lineIds[0]);
            top = el.offsetTop;
            height = el.offsetHeight;
            parent = el.parentElement.parentElement;
          if (lineIds.length > 1) {
            const lastEl = window.document.getElementById(lineIds[lineIds.length - 1]);
            const bottom = lastEl.offsetTop + lastEl.offsetHeight;
            height = bottom - top;
          }
          if (top !== null && height !== null && parent !== null) {
            // cook up a div (if necessary) and position it 
            let div = window.document.getElementById("code-annotation-line-highlight");
            if (div === null) {
              div = window.document.createElement("div");
              div.setAttribute("id", "code-annotation-line-highlight");
              div.style.position = 'absolute';
              parent.appendChild(div);
            }
            div.style.top = top - 2 + "px";
            div.style.height = height + 4 + "px";
            let gutterDiv = window.document.getElementById("code-annotation-line-highlight-gutter");
            if (gutterDiv === null) {
              gutterDiv = window.document.createElement("div");
              gutterDiv.setAttribute("id", "code-annotation-line-highlight-gutter");
              gutterDiv.style.position = 'absolute';
              const codeCell = window.document.getElementById(targetCell);
              const gutter = codeCell.querySelector('.code-annotation-gutter');
              gutter.appendChild(gutterDiv);
            }
            gutterDiv.style.top = top - 2 + "px";
            gutterDiv.style.height = height + 4 + "px";
          }
          selectedAnnoteEl = annoteEl;
        }
      };
      const unselectCodeLines = () => {
        const elementsIds = ["code-annotation-line-highlight", "code-annotation-line-highlight-gutter"];
        elementsIds.forEach((elId) => {
          const div = window.document.getElementById(elId);
          if (div) {
            div.remove();
          }
        });
        selectedAnnoteEl = undefined;
      };
      // Attach click handler to the DT
      const annoteDls = window.document.querySelectorAll('dt[data-target-cell]');
      for (const annoteDlNode of annoteDls) {
        annoteDlNode.addEventListener('click', (event) => {
          const clickedEl = event.target;
          if (clickedEl !== selectedAnnoteEl) {
            unselectCodeLines();
            const activeEl = window.document.querySelector('dt[data-target-cell].code-annotation-active');
            if (activeEl) {
              activeEl.classList.remove('code-annotation-active');
            }
            selectCodeLines(clickedEl);
            clickedEl.classList.add('code-annotation-active');
          } else {
            // Unselect the line
            unselectCodeLines();
            clickedEl.classList.remove('code-annotation-active');
          }
        });
      }
  const findCites = (el) => {
    const parentEl = el.parentElement;
    if (parentEl) {
      const cites = parentEl.dataset.cites;
      if (cites) {
        return {
          el,
          cites: cites.split(' ')
        };
      } else {
        return findCites(el.parentElement)
      }
    } else {
      return undefined;
    }
  };
  var bibliorefs = window.document.querySelectorAll('a[role="doc-biblioref"]');
  for (var i=0; i<bibliorefs.length; i++) {
    const ref = bibliorefs[i];
    const citeInfo = findCites(ref);
    if (citeInfo) {
      tippyHover(citeInfo.el, function() {
        var popup = window.document.createElement('div');
        citeInfo.cites.forEach(function(cite) {
          var citeDiv = window.document.createElement('div');
          citeDiv.classList.add('hanging-indent');
          citeDiv.classList.add('csl-entry');
          var biblioDiv = window.document.getElementById('ref-' + cite);
          if (biblioDiv) {
            citeDiv.innerHTML = biblioDiv.innerHTML;
          }
          popup.appendChild(citeDiv);
        });
        return popup.innerHTML;
      });
    }
  }
});
</script>
</div> <!-- /content -->



</body></html>