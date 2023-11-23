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
<span id="cb3-2"><a href="#cb3-2" aria-hidden="true" tabindex="-1"></a><span class="fu">library</span>(<span class="st">"countrycode"</span>)</span></code><button title="Copy to Clipboard" class="code-copy-button"><i class="bi"></i></button></pre></div>
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
<span id="cb5-8"><a href="#cb5-8" aria-hidden="true" tabindex="-1"></a>primary_color <span class="ot">&lt;-</span> <span class="st">"#429696"</span></span></code><button title="Copy to Clipboard" class="code-copy-button"><i class="bi"></i></button></pre></div>
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
<div class="sourceCode cell-code" id="cb8"><pre class="sourceCode r code-with-copy"><code class="sourceCode r"><span id="cb8-1"><a href="#cb8-1" aria-hidden="true" tabindex="-1"></a>data <span class="sc">|&gt;</span></span>
<span id="cb8-2"><a href="#cb8-2" aria-hidden="true" tabindex="-1"></a>  <span class="fu">ggplot</span>() <span class="sc">+</span></span>
<span id="cb8-3"><a href="#cb8-3" aria-hidden="true" tabindex="-1"></a>  <span class="fu">aes</span>(<span class="at">y =</span> <span class="fu">fct_rev</span>(<span class="fu">fct_infreq</span>(Age))) <span class="sc">+</span></span>
<span id="cb8-4"><a href="#cb8-4" aria-hidden="true" tabindex="-1"></a>  <span class="fu">geom_bar</span>(<span class="at">fill =</span> primary_color, <span class="at">alpha =</span> <span class="fl">0.8</span>) <span class="sc">+</span></span>
<span id="cb8-5"><a href="#cb8-5" aria-hidden="true" tabindex="-1"></a>  <span class="fu">geom_text</span>(</span>
<span id="cb8-6"><a href="#cb8-6" aria-hidden="true" tabindex="-1"></a>    <span class="fu">aes</span>(<span class="at">label =</span> scales<span class="sc">::</span><span class="fu">percent</span>(<span class="fu">after_stat</span>(count)<span class="sc">/</span><span class="fu">sum</span>(count))),</span>
<span id="cb8-7"><a href="#cb8-7" aria-hidden="true" tabindex="-1"></a>    <span class="at">stat =</span> <span class="st">"count"</span>,</span>
<span id="cb8-8"><a href="#cb8-8" aria-hidden="true" tabindex="-1"></a>    <span class="at">hjust =</span> <span class="sc">-</span><span class="fl">0.2</span>,</span>
<span id="cb8-9"><a href="#cb8-9" aria-hidden="true" tabindex="-1"></a>    <span class="at">size =</span> <span class="dv">3</span>,</span>
<span id="cb8-10"><a href="#cb8-10" aria-hidden="true" tabindex="-1"></a>    <span class="at">color =</span> <span class="st">"black"</span></span>
<span id="cb8-11"><a href="#cb8-11" aria-hidden="true" tabindex="-1"></a>  ) <span class="sc">+</span></span>
<span id="cb8-12"><a href="#cb8-12" aria-hidden="true" tabindex="-1"></a>  <span class="fu">labs</span>(<span class="at">x =</span> <span class="cn">NULL</span>, <span class="at">y =</span> <span class="cn">NULL</span>, <span class="at">title =</span> <span class="st">"How old are the participants?"</span>) <span class="sc">+</span></span>
<span id="cb8-13"><a href="#cb8-13" aria-hidden="true" tabindex="-1"></a>  <span class="fu">annotate</span>(</span>
<span id="cb8-14"><a href="#cb8-14" aria-hidden="true" tabindex="-1"></a>    <span class="st">"label"</span>,</span>
<span id="cb8-15"><a href="#cb8-15" aria-hidden="true" tabindex="-1"></a>    <span class="at">x =</span> <span class="dv">40000</span>, <span class="at">y =</span> <span class="fl">1.5</span>,</span>
<span id="cb8-16"><a href="#cb8-16" aria-hidden="true" tabindex="-1"></a>    <span class="at">label =</span> <span class="fu">paste</span>(<span class="st">"Total Number of Participents:"</span>, scales<span class="sc">::</span><span class="fu">comma</span>(<span class="fu">nrow</span>(data))),</span>
<span id="cb8-17"><a href="#cb8-17" aria-hidden="true" tabindex="-1"></a>    <span class="at">color =</span> <span class="st">"black"</span>,</span>
<span id="cb8-18"><a href="#cb8-18" aria-hidden="true" tabindex="-1"></a>    <span class="at">size=</span><span class="dv">3</span></span>
<span id="cb8-19"><a href="#cb8-19" aria-hidden="true" tabindex="-1"></a>  ) <span class="sc">+</span></span>
<span id="cb8-20"><a href="#cb8-20" aria-hidden="true" tabindex="-1"></a>  <span class="fu">theme_minimal</span>() <span class="sc">+</span></span>
<span id="cb8-21"><a href="#cb8-21" aria-hidden="true" tabindex="-1"></a>  <span class="fu">scale_x_continuous</span>(<span class="at">labels =</span> scales<span class="sc">::</span>comma, <span class="at">limits =</span> <span class="fu">c</span>(<span class="dv">0</span>, <span class="dv">50000</span>)) <span class="sc">+</span></span>
<span id="cb8-22"><a href="#cb8-22" aria-hidden="true" tabindex="-1"></a>  adjust_spacing </span></code><button title="Copy to Clipboard" class="code-copy-button"><i class="bi"></i></button></pre></div>
<div class="cell-output-display">
<p><img src="analysis_files/figure-html/unnamed-chunk-5-1.png" class="img-fluid" width="672"></p>
</div>
</div>
<div class="cell">
<div class="sourceCode cell-code" id="cb9"><pre class="sourceCode r code-with-copy"><code class="sourceCode r"><span id="cb9-1"><a href="#cb9-1" aria-hidden="true" tabindex="-1"></a>employment_df <span class="ot">&lt;-</span> data <span class="sc">|&gt;</span> </span>
<span id="cb9-2"><a href="#cb9-2" aria-hidden="true" tabindex="-1"></a>  <span class="fu">select</span>(ResponseId, Employment) <span class="sc">|&gt;</span> </span>
<span id="cb9-3"><a href="#cb9-3" aria-hidden="true" tabindex="-1"></a>  <span class="fu">separate_rows</span>(Employment, <span class="at">sep=</span><span class="st">";"</span>) <span class="sc">|&gt;</span> </span>
<span id="cb9-4"><a href="#cb9-4" aria-hidden="true" tabindex="-1"></a>  <span class="fu">mutate</span>(<span class="at">Employment=</span><span class="fu">trimws</span>(Employment)) <span class="sc">|&gt;</span> </span>
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
<span id="cb9-20"><a href="#cb9-20" aria-hidden="true" tabindex="-1"></a>  <span class="fu">lims</span>(<span class="at">x =</span> <span class="fu">c</span>(<span class="dv">0</span>, <span class="dv">70000</span>)) <span class="sc">+</span></span>
<span id="cb9-21"><a href="#cb9-21" aria-hidden="true" tabindex="-1"></a>  <span class="fu">theme_minimal</span>() <span class="sc">+</span></span>
<span id="cb9-22"><a href="#cb9-22" aria-hidden="true" tabindex="-1"></a>  adjust_spacing <span class="sc">+</span> </span>
<span id="cb9-23"><a href="#cb9-23" aria-hidden="true" tabindex="-1"></a>  <span class="fu">scale_x_continuous</span>(<span class="at">labels =</span> scales<span class="sc">::</span>comma)</span></code><button title="Copy to Clipboard" class="code-copy-button"><i class="bi"></i></button></pre></div>
<div class="cell-output cell-output-stderr">
<pre><code>Scale for x is already present.
Adding another scale for x, which will replace the existing scale.</code></pre>
</div>
<div class="cell-output-display">
<p><img src="analysis_files/figure-html/unnamed-chunk-6-1.png" class="img-fluid" width="672"></p>
</div>
</div>
<div class="cell">
<div class="sourceCode cell-code" id="cb11"><pre class="sourceCode r code-with-copy"><code class="sourceCode r"><span id="cb11-1"><a href="#cb11-1" aria-hidden="true" tabindex="-1"></a>continent_data <span class="ot">&lt;-</span> data <span class="sc">|&gt;</span></span>
<span id="cb11-2"><a href="#cb11-2" aria-hidden="true" tabindex="-1"></a>  <span class="fu">mutate</span>(<span class="at">Continent =</span> <span class="fu">countrycode</span>(</span>
<span id="cb11-3"><a href="#cb11-3" aria-hidden="true" tabindex="-1"></a>    <span class="at">sourcevar =</span> Country,</span>
<span id="cb11-4"><a href="#cb11-4" aria-hidden="true" tabindex="-1"></a>    <span class="at">origin =</span> <span class="st">"country.name"</span>,</span>
<span id="cb11-5"><a href="#cb11-5" aria-hidden="true" tabindex="-1"></a>    <span class="at">destination =</span> <span class="st">"continent"</span></span>
<span id="cb11-6"><a href="#cb11-6" aria-hidden="true" tabindex="-1"></a>  )) <span class="sc">|&gt;</span></span>
<span id="cb11-7"><a href="#cb11-7" aria-hidden="true" tabindex="-1"></a>  <span class="fu">drop_na</span>(Continent) <span class="sc">|&gt;</span> </span>
<span id="cb11-8"><a href="#cb11-8" aria-hidden="true" tabindex="-1"></a>  <span class="fu">group_by</span>(Continent, Country) <span class="sc">|&gt;</span> </span>
<span id="cb11-9"><a href="#cb11-9" aria-hidden="true" tabindex="-1"></a>  <span class="fu">summarise</span>(<span class="at">freq=</span> <span class="fu">n</span>()) <span class="sc">|&gt;</span> </span>
<span id="cb11-10"><a href="#cb11-10" aria-hidden="true" tabindex="-1"></a>  <span class="fu">mutate</span>(</span>
<span id="cb11-11"><a href="#cb11-11" aria-hidden="true" tabindex="-1"></a>    <span class="at">Country =</span> <span class="fu">case_when</span>(</span>
<span id="cb11-12"><a href="#cb11-12" aria-hidden="true" tabindex="-1"></a>      Country <span class="sc">==</span> <span class="st">"United States of America"</span> <span class="sc">~</span> <span class="st">"USA"</span>,</span>
<span id="cb11-13"><a href="#cb11-13" aria-hidden="true" tabindex="-1"></a>      Country <span class="sc">==</span> <span class="st">"United Kingdom of Great Britain and Northern Ireland"</span> <span class="sc">~</span> <span class="st">"UK"</span>,</span>
<span id="cb11-14"><a href="#cb11-14" aria-hidden="true" tabindex="-1"></a>      <span class="cn">TRUE</span> <span class="sc">~</span> Country</span>
<span id="cb11-15"><a href="#cb11-15" aria-hidden="true" tabindex="-1"></a>    )</span>
<span id="cb11-16"><a href="#cb11-16" aria-hidden="true" tabindex="-1"></a>  )</span></code><button title="Copy to Clipboard" class="code-copy-button"><i class="bi"></i></button></pre></div>
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
<div class="sourceCode cell-code" id="cb14"><pre class="sourceCode r code-with-copy"><code class="sourceCode r"><span id="cb14-1"><a href="#cb14-1" aria-hidden="true" tabindex="-1"></a>continent_data <span class="sc">|&gt;</span></span>
<span id="cb14-2"><a href="#cb14-2" aria-hidden="true" tabindex="-1"></a>  <span class="fu">ggplot</span>() <span class="sc">+</span></span>
<span id="cb14-3"><a href="#cb14-3" aria-hidden="true" tabindex="-1"></a>  <span class="fu">aes</span>(<span class="at">y =</span> Continent,</span>
<span id="cb14-4"><a href="#cb14-4" aria-hidden="true" tabindex="-1"></a>      <span class="at">x =</span> freq,</span>
<span id="cb14-5"><a href="#cb14-5" aria-hidden="true" tabindex="-1"></a>      <span class="at">fill =</span> <span class="fu">fct_lump</span>(Country, <span class="at">n=</span><span class="dv">10</span>, <span class="at">w=</span>freq)) <span class="sc">+</span></span>
<span id="cb14-6"><a href="#cb14-6" aria-hidden="true" tabindex="-1"></a>  <span class="fu">geom_col</span>() <span class="sc">+</span></span>
<span id="cb14-7"><a href="#cb14-7" aria-hidden="true" tabindex="-1"></a>  <span class="fu">labs</span>(<span class="at">title =</span> <span class="st">"Diversity of Respondants"</span>, <span class="at">x =</span> <span class="cn">NULL</span>, <span class="at">y =</span> <span class="cn">NULL</span>, <span class="at">fill=</span><span class="cn">NULL</span>) <span class="sc">+</span></span>
<span id="cb14-8"><a href="#cb14-8" aria-hidden="true" tabindex="-1"></a>  <span class="fu">theme_minimal</span>()<span class="sc">+</span> </span>
<span id="cb14-9"><a href="#cb14-9" aria-hidden="true" tabindex="-1"></a>  <span class="fu">scale_fill_brewer</span>(<span class="at">palette =</span> <span class="st">"Set3"</span>) <span class="sc">+</span></span>
<span id="cb14-10"><a href="#cb14-10" aria-hidden="true" tabindex="-1"></a>  adjust_spacing <span class="sc">+</span></span>
<span id="cb14-11"><a href="#cb14-11" aria-hidden="true" tabindex="-1"></a>  <span class="fu">scale_x_continuous</span>(<span class="at">labels =</span> scales<span class="sc">::</span>comma)</span></code><button title="Copy to Clipboard" class="code-copy-button"><i class="bi"></i></button></pre></div>
<div class="cell-output-display">
<p><img src="analysis_files/figure-html/unnamed-chunk-7-1.png" class="img-fluid" width="672"></p>
</div>
</div>
<div class="cell">
<div class="sourceCode cell-code" id="cb15"><pre class="sourceCode r code-with-copy"><code class="sourceCode r"><span id="cb15-1"><a href="#cb15-1" aria-hidden="true" tabindex="-1"></a>continent_data <span class="sc">|&gt;</span> </span>
<span id="cb15-2"><a href="#cb15-2" aria-hidden="true" tabindex="-1"></a>  <span class="fu">arrange</span>(<span class="fu">desc</span>(freq))</span></code><button title="Copy to Clipboard" class="code-copy-button"><i class="bi"></i></button></pre></div>
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
<div class="sourceCode cell-code" id="cb17"><pre class="sourceCode r code-with-copy"><code class="sourceCode r"><span id="cb17-1"><a href="#cb17-1" aria-hidden="true" tabindex="-1"></a>eu <span class="ot">&lt;-</span> data <span class="sc">|&gt;</span> </span>
<span id="cb17-2"><a href="#cb17-2" aria-hidden="true" tabindex="-1"></a>  <span class="fu">filter</span>(Country <span class="sc">%in%</span> eu_countries<span class="sc">$</span>name)</span>
<span id="cb17-3"><a href="#cb17-3" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb17-4"><a href="#cb17-4" aria-hidden="true" tabindex="-1"></a></span>
<span id="cb17-5"><a href="#cb17-5" aria-hidden="true" tabindex="-1"></a>eu <span class="sc">|&gt;</span></span>
<span id="cb17-6"><a href="#cb17-6" aria-hidden="true" tabindex="-1"></a>  <span class="fu">ggplot</span>() <span class="sc">+</span></span>
<span id="cb17-7"><a href="#cb17-7" aria-hidden="true" tabindex="-1"></a>  <span class="fu">aes</span>(<span class="at">y =</span> <span class="fu">fct_rev</span>(<span class="fu">fct_infreq</span>(Country))) <span class="sc">+</span></span>
<span id="cb17-8"><a href="#cb17-8" aria-hidden="true" tabindex="-1"></a>  <span class="fu">geom_bar</span>(<span class="at">fill =</span> primary_color, <span class="at">alpha =</span> <span class="fl">0.8</span>) <span class="sc">+</span></span>
<span id="cb17-9"><a href="#cb17-9" aria-hidden="true" tabindex="-1"></a>  <span class="fu">geom_text</span>(</span>
<span id="cb17-10"><a href="#cb17-10" aria-hidden="true" tabindex="-1"></a>    <span class="fu">aes</span>(<span class="at">label =</span> scales<span class="sc">::</span><span class="fu">percent</span>(<span class="fu">after_stat</span>(count)<span class="sc">/</span><span class="fu">sum</span>(count))),</span>
<span id="cb17-11"><a href="#cb17-11" aria-hidden="true" tabindex="-1"></a>    <span class="at">stat =</span> <span class="st">"count"</span>,</span>
<span id="cb17-12"><a href="#cb17-12" aria-hidden="true" tabindex="-1"></a>    <span class="at">hjust =</span> <span class="sc">-</span><span class="fl">0.2</span>,</span>
<span id="cb17-13"><a href="#cb17-13" aria-hidden="true" tabindex="-1"></a>    <span class="at">size =</span> <span class="dv">3</span>,</span>
<span id="cb17-14"><a href="#cb17-14" aria-hidden="true" tabindex="-1"></a>    <span class="at">color =</span> <span class="st">"black"</span></span>
<span id="cb17-15"><a href="#cb17-15" aria-hidden="true" tabindex="-1"></a>  ) <span class="sc">+</span></span>
<span id="cb17-16"><a href="#cb17-16" aria-hidden="true" tabindex="-1"></a>  <span class="fu">labs</span>(<span class="at">x =</span> <span class="cn">NULL</span>, <span class="at">y =</span> <span class="cn">NULL</span>, <span class="at">title =</span> <span class="st">"How old are the participants?"</span>) <span class="sc">+</span></span>
<span id="cb17-17"><a href="#cb17-17" aria-hidden="true" tabindex="-1"></a>  <span class="fu">annotate</span>(</span>
<span id="cb17-18"><a href="#cb17-18" aria-hidden="true" tabindex="-1"></a>    <span class="st">"label"</span>,</span>
<span id="cb17-19"><a href="#cb17-19" aria-hidden="true" tabindex="-1"></a>    <span class="at">x =</span> <span class="dv">8000</span>, <span class="at">y =</span> <span class="dv">3</span>,</span>
<span id="cb17-20"><a href="#cb17-20" aria-hidden="true" tabindex="-1"></a>    <span class="at">label =</span> <span class="fu">paste</span>(<span class="st">"Total Number of Participents:"</span>, scales<span class="sc">::</span><span class="fu">comma</span>(<span class="fu">nrow</span>(eu))),</span>
<span id="cb17-21"><a href="#cb17-21" aria-hidden="true" tabindex="-1"></a>    <span class="at">color =</span> <span class="st">"black"</span>,</span>
<span id="cb17-22"><a href="#cb17-22" aria-hidden="true" tabindex="-1"></a>    <span class="at">size=</span><span class="dv">3</span></span>
<span id="cb17-23"><a href="#cb17-23" aria-hidden="true" tabindex="-1"></a>  ) <span class="sc">+</span></span>
<span id="cb17-24"><a href="#cb17-24" aria-hidden="true" tabindex="-1"></a>  <span class="fu">lims</span>(<span class="at">x=</span><span class="fu">c</span>(<span class="dv">0</span>,<span class="dv">10000</span>))<span class="sc">+</span></span>
<span id="cb17-25"><a href="#cb17-25" aria-hidden="true" tabindex="-1"></a>  <span class="fu">theme_minimal</span>() <span class="sc">+</span></span>
<span id="cb17-26"><a href="#cb17-26" aria-hidden="true" tabindex="-1"></a>  adjust_spacing</span></code><button title="Copy to Clipboard" class="code-copy-button"><i class="bi"></i></button></pre></div>
<div class="cell-output-display">
<p><img src="analysis_files/figure-html/unnamed-chunk-9-1.png" class="img-fluid" width="672"></p>
</div>
</div>
</section>

</main>
<!-- /main column -->

</div> <!-- /content -->



</body></html>