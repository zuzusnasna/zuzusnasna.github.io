---
layout: default
title: 글쓰기
permalink: /write/
noindex: true
---

<section class="write-page">
  <header class="write-head">
    <div class="write-head-copy">
      <p class="eyebrow">STUDY NOTES</p>
      <h1>글쓰기</h1>
      <p>제목과 본문을 적고, 미리보기에서 확인한 뒤 Markdown 파일로 저장합니다.</p>
    </div>
    <div class="write-actions">
      <div class="write-action-buttons">
        <button type="button" id="reset-post">새 글</button>
        <button type="button" id="download-post" class="primary">Markdown 저장</button>
      </div>
      <p class="status" id="status" role="status" aria-live="polite">초안은 이 브라우저에 자동 저장됩니다.</p>
    </div>
  </header>

  <div class="write-grid">
    <section class="editor-panel" aria-labelledby="editor-heading">
      <div class="panel-heading">
        <div><span class="panel-index">01 / WRITE</span><h2 id="editor-heading">글 정보</h2></div>
        <span class="panel-hint">작성한 글은 브라우저에 저장됩니다.</span>
      </div>

      <div class="write-fields">
        <label class="write-field write-field-title" for="post-title">
          <span>제목</span>
          <input id="post-title" type="text" maxlength="160" autocomplete="off" placeholder="글 제목">
        </label>
        <div class="write-field-row">
          <label class="write-field" for="post-date">
            <span>날짜</span>
            <input id="post-date" type="date">
          </label>
          <label class="write-field" for="post-tags">
            <span>태그 <small>쉼표로 구분</small></span>
            <input id="post-tags" type="text" maxlength="500" autocomplete="off" placeholder="Java, Spring">
          </label>
        </div>
        <div class="write-field">
          <label for="post-category"><span>분류</span></label>
          <div class="category-row">
            <select id="post-category">
              <option value="auto" selected>본문을 보고 자동으로 선택</option>
              <optgroup label="Java">
                <option value="section:java-core" data-section="java-core" data-parent="java" data-label="Java 기본">Java 기본</option>
                <option value="section:java-oop" data-section="java-oop" data-parent="java" data-label="객체지향 / SOLID">객체지향 / SOLID</option>
                <option value="section:java-pattern" data-section="java-pattern" data-parent="java" data-label="디자인 패턴">디자인 패턴</option>
                <option value="section:java-generics" data-section="java-generics" data-parent="java" data-label="Generic">Generic</option>
                <option value="section:java-functional" data-section="java-functional" data-parent="java" data-label="함수형 / Lambda / Stream">함수형 / Lambda / Stream</option>
                <option value="section:java-collections" data-section="java-collections" data-parent="java" data-label="컬렉션">컬렉션</option>
                <option value="section:java-jvm" data-section="java-jvm" data-parent="java" data-label="JVM">JVM</option>
                <option value="section:java-concurrency" data-section="java-concurrency" data-parent="java" data-label="동시성">동시성</option>
                <option value="section:java-io" data-section="java-io" data-parent="java" data-label="입출력 / NIO">입출력 / NIO</option>
              </optgroup>
              <optgroup label="Spring">
                <option value="section:spring-core" data-section="spring-core" data-parent="spring" data-label="Spring Core / DI / AOP">Spring Core / DI / AOP</option>
                <option value="section:spring-data" data-section="spring-data" data-parent="spring" data-label="JPA / MyBatis">JPA / MyBatis</option>
                <option value="section:spring-web" data-section="spring-web" data-parent="spring" data-label="MVC / WebFlux / REST API">MVC / WebFlux / REST API</option>
                <option value="section:spring-security" data-section="spring-security" data-parent="spring" data-label="Security / JWT / OAuth2">Security / JWT / OAuth2</option>
                <option value="section:spring-testing" data-section="spring-testing" data-parent="spring" data-label="테스트 / 품질 관리">테스트 / 품질 관리</option>
                <option value="section:spring-ai" data-section="spring-ai" data-parent="spring" data-label="Spring AI">Spring AI</option>
              </optgroup>
              <optgroup label="Database">
                <option value="section:database-oracle" data-section="database-oracle" data-parent="database" data-label="Oracle / SQL / PL-SQL">Oracle / SQL / PL-SQL</option>
                <option value="section:database-redis" data-section="database-redis" data-parent="database" data-label="Redis">Redis</option>
                <option value="section:database-storage" data-section="database-storage" data-parent="database" data-label="MySQL / Docker Volume">MySQL / Docker Volume</option>
              </optgroup>
              <optgroup label="Backend">
                <option value="section:backend-messaging" data-section="backend-messaging" data-parent="backend" data-label="실시간 / 메시징">실시간 / 메시징</option>
                <option value="section:backend-performance" data-section="backend-performance" data-parent="backend" data-label="성능 / 부하 테스트">성능 / 부하 테스트</option>
              </optgroup>
              <optgroup label="Frontend">
                <option value="section:frontend-html" data-section="frontend-html" data-parent="frontend" data-label="HTML / CSS / JavaScript">HTML / CSS / JavaScript</option>
                <option value="section:frontend-react" data-section="frontend-react" data-parent="frontend" data-label="React">React</option>
              </optgroup>
              <optgroup label="Infra">
                <option value="section:infra-linux" data-section="infra-linux" data-parent="infra" data-label="Linux">Linux</option>
                <option value="section:infra-aws" data-section="infra-aws" data-parent="infra" data-label="AWS / EC2">AWS / EC2</option>
                <option value="section:infra-docker" data-section="infra-docker" data-parent="infra" data-label="Docker">Docker</option>
                <option value="section:infra-cicd" data-section="infra-cicd" data-parent="infra" data-label="GitHub Actions / CI-CD">GitHub Actions / CI-CD</option>
              </optgroup>
              <optgroup label="ML">
                <option value="section:ml" data-section="ml" data-parent="ml" data-label="Machine Learning">Machine Learning</option>
              </optgroup>
              <optgroup label="기타"><option value="section:other" data-section="other" data-parent="other" data-label="기타">기타</option></optgroup>
              {% assign built_in_sections = 'java-core,java-oop,java-pattern,java-generics,java-functional,java-collections,java-jvm,java-concurrency,java-io,spring-core,spring-data,spring-web,spring-security,spring-testing,spring-ai,database-oracle,database-redis,database-storage,backend-messaging,backend-performance,frontend-html,frontend-react,infra-linux,infra-aws,infra-docker,infra-cicd,ml,other' | split: ',' %}
              {% assign saved_sections = site.posts | map: 'section' | compact | uniq | sort_natural %}
              {% assign custom_count = 0 %}
              {% for saved_section in saved_sections %}
                {% unless built_in_sections contains saved_section %}{% assign custom_count = custom_count | plus: 1 %}{% endunless %}
              {% endfor %}
              {% if custom_count > 0 %}<optgroup label="내 분류">
              {% for saved_section in saved_sections %}
                {% unless built_in_sections contains saved_section %}
                  {% assign saved_post = site.posts | where: 'section', saved_section | first %}
                  <option value="section:{{ saved_section | escape }}" data-section="{{ saved_section | escape }}" data-parent="custom" data-label="{{ saved_post.section_label | default: saved_section | escape }}">{{ saved_post.section_label | default: saved_section | escape }}</option>
                {% endunless %}
              {% endfor %}
              </optgroup>{% endif %}
              <option value="new">새 분류 만들기</option>
            </select>
            <button type="button" id="add-category" class="secondary-button">분류 추가</button>
          </div>
          <div class="custom-category" id="custom-category-fields" hidden>
            <label class="sr-only" for="custom-category-name">새 분류 이름</label>
            <input id="custom-category-name" type="text" maxlength="60" autocomplete="off" aria-describedby="custom-category-help" placeholder="예: Kotlin, 네트워크">
            <p id="custom-category-help">저장한 글을 블로그에 올리면 이 분류가 목록에 추가됩니다.</p>
          </div>
        </div>
        <div class="write-meta" aria-live="polite">
          <span id="meta-summary">분류는 본문 내용을 기준으로 자동 선택됩니다.</span>
        </div>
      </div>

      <div class="body-editor-heading"><h3>본문</h3><span>MARKDOWN</span></div>
      <div class="editor-toolbar" role="toolbar" aria-label="Markdown 서식">
        <button type="button" data-action="bold" aria-label="굵게" title="굵게"><strong>B</strong></button>
        <button type="button" data-action="heading" aria-label="소제목" title="소제목">H2</button>
        <button type="button" data-action="code" aria-label="코드 블록" title="코드 블록">{ }</button>
        <button type="button" data-action="quote" aria-label="인용문" title="인용문">❝</button>
        <button type="button" data-action="list" aria-label="목록" title="목록">• 목록</button>
        <button type="button" data-action="table" aria-label="표" title="표">표</button>
        <button type="button" data-action="link" aria-label="링크" title="링크">링크</button>
      </div>
      <label class="sr-only" for="post-body">Markdown 본문</label>
      <textarea id="post-body" spellcheck="false" placeholder="Markdown 본문을 적거나 글 전체를 붙여넣으세요.

글 전체를 붙여넣으면 Front Matter의 제목, 날짜, 태그, 분류를 읽습니다.

## 다룰 내용
어떤 문제나 개념을 정리하는지 적습니다.

## 동작과 예제
필요한 코드, 표, 명령어를 넣습니다.

## 직접 확인한 결과
실행 결과나 참고한 문서를 적습니다."></textarea>
    </section>

    <section class="preview-panel" aria-labelledby="preview-heading">
      <div class="panel-heading preview-heading">
        <div><span class="panel-index">02 / PREVIEW</span><h2 id="preview-heading">미리보기</h2></div>
        <span class="preview-state" id="preview-state">작성 중</span>
      </div>
      <article class="post-content" id="post-preview">
        <h1 class="preview-title" id="preview-title" hidden></h1>
        <div id="preview-body"><p class="preview-empty">본문을 입력하면 여기에서 확인할 수 있습니다.</p></div>
      </article>
    </section>
  </div>

  <div class="write-notes">
    <p class="write-note"><strong>분류</strong> · 기존 분류를 고르거나 새 분류를 만들 수 있습니다. 새 분류 이름은 글의 Front Matter에 들어가며, 글을 <code>_posts</code>에 추가하면 블로그 목록에도 나타납니다.</p>
    <p class="write-note"><strong>저장</strong> · 임시 초안은 현재 브라우저에 저장됩니다. Markdown 파일을 내려받은 뒤 블로그 저장소의 <code>_posts</code>에 넣어 게시합니다.</p>
    <p class="write-note"><strong>글 구성</strong> · 질문, 핵심 내용, 예제, 직접 확인한 결과 순으로 쓰면 정리하기 쉽습니다. 글에 맞지 않는 부분은 빼도 됩니다.</p>
  </div>
</section>

<script src="https://cdn.jsdelivr.net/npm/marked@15.0.12/marked.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/dompurify@3.2.6/dist/purify.min.js"></script>
<script>
(() => {
  const body = document.getElementById('post-body');
  const titleInput = document.getElementById('post-title');
  const dateInput = document.getElementById('post-date');
  const tagsInput = document.getElementById('post-tags');
  const categorySelect = document.getElementById('post-category');
  const customFields = document.getElementById('custom-category-fields');
  const customCategoryInput = document.getElementById('custom-category-name');
  const previewTitle = document.getElementById('preview-title');
  const previewBody = document.getElementById('preview-body');
  const status = document.getElementById('status');
  const metaSummary = document.getElementById('meta-summary');
  const previewState = document.getElementById('preview-state');
  const draftKey = 'zuzusnasna-study-draft';
  const tick = String.fromCharCode(96);
  const fencePattern = new RegExp('^ {0,3}(' + tick + '{3,}|~{3,})');

  const today = () => {
    const date = new Date();
    return new Date(date.getTime() - date.getTimezoneOffset() * 60000).toISOString().slice(0, 10);
  };

  const parseScalar = raw => {
    const value = String(raw || '').trim();
    if (value.length >= 2 && value[0] === '"' && value[value.length - 1] === '"') {
      try { return JSON.parse(value); } catch (_) { return value.slice(1, -1); }
    }
    if (value.length >= 2 && value[0] === "'" && value[value.length - 1] === "'") {
      return value.slice(1, -1).replace(/''/g, "'");
    }
    return value;
  };

  const splitYamlList = raw => {
    let value = String(raw || '').trim();
    if (value.startsWith('[') && value.endsWith(']')) value = value.slice(1, -1);
    const parts = [];
    let current = '';
    let quote = '';
    let escaped = false;
    for (let i = 0; i < value.length; i++) {
      const char = value[i];
      if (escaped) { current += char; escaped = false; continue; }
      if (quote === '"' && char === '\\') { current += char; escaped = true; continue; }
      if (quote) {
        if (char === quote) {
          if (quote === "'" && value[i + 1] === "'") { current += "''"; i++; continue; }
          quote = '';
        }
        current += char;
        continue;
      }
      if (char === '"' || char === "'") { quote = char; current += char; continue; }
      if (char === ',') { parts.push(parseScalar(current)); current = ''; continue; }
      current += char;
    }
    if (current.trim()) parts.push(parseScalar(current));
    return parts.map(item => String(item).trim()).filter(Boolean);
  };

  const parseYaml = raw => {
    const value = String(raw || '').trim();
    if (value.startsWith('[') && value.endsWith(']')) return splitYamlList(value);
    return parseScalar(value);
  };

  const readFrontMatter = source => {
    const cleaned = String(source || '').replace(/^\uFEFF/, '').trimStart();
    const match = cleaned.match(/^---\r?\n([\s\S]*?)\r?\n---(?:\r?\n|$)/);
    if (!match) return null;
    const data = {};
    const lines = match[1].split(/\r?\n/);
    for (let i = 0; i < lines.length; i++) {
      const item = lines[i].match(/^([A-Za-z0-9_-]+):(?:\s*(.*))?$/);
      if (!item) continue;
      const key = item[1];
      const value = item[2] || '';
      if (!value) {
        const list = [];
        let next = i + 1;
        while (next < lines.length) {
          const listItem = lines[next].match(/^\s+-\s+(.*)$/);
          if (!listItem) break;
          list.push(parseScalar(listItem[1]));
          next++;
        }
        data[key] = list.length ? list : '';
        i = next - 1;
      } else {
        data[key] = parseYaml(value);
      }
    }
    return {data, body: cleaned.slice(match[0].length).trimStart()};
  };

  const stripFrontMatter = source => {
    let cleaned = String(source || '').replace(/^\uFEFF/, '').trimStart();
    let previous = null;
    while (cleaned !== previous) {
      previous = cleaned;
      const match = cleaned.match(/^---\r?\n[\s\S]*?\r?\n---(?:\r?\n|$)/);
      if (!match) break;
      cleaned = cleaned.slice(match[0].length).trimStart();
    }
    return cleaned;
  };

  const normalizeDate = value => {
    const raw = String(value || '').trim();
    if (!raw) return '';
    const match = raw.match(/\b(\d{4})-(\d{2})-(\d{2})\b/);
    if (!match) return '';
    const year = Number(match[1]), month = Number(match[2]), day = Number(match[3]);
    const date = new Date(Date.UTC(year, month - 1, day));
    if (date.getUTCFullYear() !== year || date.getUTCMonth() !== month - 1 || date.getUTCDate() !== day) return '';
    return match[1] + '-' + match[2] + '-' + match[3];
  };

  const normalizeTags = value => {
    if (Array.isArray(value)) return value.map(tag => String(tag).trim()).filter(Boolean);
    const text = String(value || '').trim();
    return text ? splitYamlList(text) : [];
  };

  const rules = [
    ['spring-ai', 'Spring', /\b(spring ai|spring-ai|chatclient|prompttemplate|ollama|openai api|embedding|vector store|retrieval augmented generation|model context protocol|mcp|rag|chat memory|chatmemory|chatmemoryrepository|messagechatmemoryadvisor)\b|생성형.?ai|벡터.?스토어|대화 기억/i],
    ['java-jvm', 'Java', /\b(jvm|jit|gc|garbage collection|heap|metaspace|class loading|classloader)\b|가비지 컬렉션|클래스 로딩/i],
    ['java-collections', 'Java', /\b(collection|arraylist|linkedlist|hashmap|hashset|treeset|deque|iterator|comparator)\b|컬렉션/i],
    ['java-concurrency', 'Java', /\b(concurrency|synchronized|reentrantlock|executorservice|completablefuture|volatile|atomic|threadlocal|deadlock|thread|lock)\b|동시성|스레드/i],
    ['java-io', 'Java', /\b(filechannel|nio|inputstream|outputstream|bufferedreader|bufferedinputstream|serialization)\b|입출력|직렬화/i],
    ['java-pattern', 'Java', /\b(design pattern|singleton|strategy|factory|observer|command|decorator|adapter|facade|builder|prototype)\b|디자인.?패턴/i],
    ['java-oop', 'Java', /\b(solid|oop|inheritance|composition|coupling|cohesion|abstract class)\b|객체지향|상속|다형성|캡슐화|추상화/i],
    ['java-functional', 'Java', /\b(lambda|stream|functional programming)\b|람다|함수형/i],
    ['java-generics', 'Java', /\bgeneric\b|제네릭/i],
    ['spring-data', 'Spring', /\b(jpa|mybatis|hibernate|entitymanager|orm|fetch join)\b/i],
    ['spring-security', 'Spring', /\b(spring security|jwt|oauth2|oauth|csrf|cors|filter chain)\b/i],
    ['spring-testing', 'Spring', /\b(junit|mockito|mockmvc|integration test|test slice)\b|테스트/i],
    ['spring-web', 'Spring', /\b(rest api|spring mvc|webflux|reactive|controller|http status|pagination|idempotency)\b|웹.?mvc/i],
    ['spring-core', 'Spring', /\b(spring|di|ioc|aop|bean|applicationcontext|transaction|proxy)\b/i],
    ['database-storage', 'Database', /\bdocker volume\b|\bbind mount\b|\bnamed volume\b|도커.?볼륨/i],
    ['database-redis', 'Database', /\b(redis|sorted set|zset|pub.?sub)\b/i],
    ['database-oracle', 'Database', /\b(oracle|sql|pl.?sql|cursor|procedure|trigger|job|query|index|execution plan|mysql|database)\b|데이터베이스|쿼리|테이블/i],
    ['backend-messaging', 'Backend', /\b(websocket|stomp|kafka|rabbitmq|message broker|pub.?sub|outbox)\b|실시간.?메시징/i],
    ['backend-performance', 'Backend', /\b(k6|load test|performance|throughput|latency|p95|benchmark)\b|성능|부하 테스트/i],
    ['frontend-react', 'Frontend', /\b(react|vite|jsx|react router)\b/i],
    ['frontend-html', 'Frontend', /\b(html|css|javascript|js|dom)\b|프론트엔드/i],
    ['infra-cicd', 'Infra', /\b(github actions|ci\/cd|cicd|continuous integration|deployment pipeline)\b|배포 자동화/i],
    ['infra-docker', 'Infra', /\b(docker|container|docker compose)\b/i],
    ['infra-aws', 'Infra', /\b(aws|ec2|amazon web services)\b/i],
    ['infra-linux', 'Infra', /\b(linux|ubuntu|shell|bash)\b/i],
    ['ml', 'ML', /\b(machine learning|knn|logistic regression|decision tree|random forest|svc|scikit.?learn|classification)\b|머신러닝|분류 모델/i]
  ];

  const classify = text => {
    for (const [section, parent] of rules) {
      if (!parent.test(text)) continue;
      const option = [...categorySelect.options].find(item => item.dataset.section === section);
      return {section, parent: parent.toLowerCase(), label: option?.dataset.label || option?.textContent.trim() || section};
    }
    return {section: 'other', parent: 'other', label: '기타'};
  };

  const normalizeHeading = value => String(value || '').toLocaleLowerCase('ko-KR').replace(/[^\p{L}\p{N}]/gu, '');
  const fenceOpening = line => line.match(fencePattern);
  const isFenceClosing = (line, char, length) => new RegExp('^ {0,3}' + char + '{' + length + ',}[ \\t]*$').test(line);

  const autoTitle = source => {
    let fenceChar = '', fenceLength = 0;
    for (const line of String(source || '').replace(/\r\n/g, '\n').split('\n')) {
      const opening = fenceOpening(line);
      if (fenceChar) {
        if (opening && opening[1][0] === fenceChar && isFenceClosing(line, fenceChar, fenceLength)) {
          fenceChar = '';
          fenceLength = 0;
        }
        continue;
      }
      if (opening) {
        fenceChar = opening[1][0];
        fenceLength = opening[1].length;
        continue;
      }
      const heading = line.match(/^ {0,3}#(?!#)\s+(.+?)\s*#*\s*$/);
      if (heading) return heading[1].trim();
    }
    return '';
  };

  const normalizeArticle = (source, title) => {
    const output = [];
    let fenceChar = '', fenceLength = 0, firstContent = false;
    const lines = String(source || '').replace(/\r\n/g, '\n').split('\n');
    for (const line of lines) {
      const opening = fenceOpening(line);
      if (fenceChar) {
        if (opening && opening[1][0] === fenceChar && isFenceClosing(line, fenceChar, fenceLength)) {
          fenceChar = '';
          fenceLength = 0;
        }
        output.push(line);
        continue;
      }
      if (opening) {
        if (!firstContent && line.trim()) firstContent = true;
        fenceChar = opening[1][0];
        fenceLength = opening[1].length;
        output.push(line);
        continue;
      }
      if (!firstContent && line.trim()) {
        firstContent = true;
        const heading = line.match(/^ {0,3}#(?!#)\s+(.+?)\s*#*\s*$/);
        if (title && heading && normalizeHeading(heading[1]) === normalizeHeading(title)) continue;
      }
      const heading = line.match(/^( {0,3})#\s+(.+)$/);
      if (heading) {
        output.push(heading[1] + '## ' + heading[2]);
      } else {
        output.push(line);
      }
    }
    return output.join('\n').trim();
  };

  const render = source => {
    if (!window.marked || !window.DOMPurify) {
      return '<p class="preview-empty">미리보기 모듈을 불러오지 못했습니다. 네트워크 연결을 확인해 주세요.</p>';
    }
    try {
      const html = window.marked.parse(String(source || ''), {gfm: true, breaks: false});
      return window.DOMPurify.sanitize(html, {USE_PROFILES: {html: true}, ADD_ATTR: ['target', 'rel']});
    } catch (_) {
      return '<p class="preview-empty">미리보기를 만들지 못했습니다. 본문을 확인해 주세요.</p>';
    }
  };

  const yamlQuote = value => JSON.stringify(String(value || '').replace(/[\u0000-\u001F\u007F]/g, ' ').trim());

  const selectedCategory = () => {
    const value = categorySelect.value;
    if (value === 'auto') return classify([titleInput.value, tagsInput.value, body.value].join(' '));
    if (value === 'new') {
      const label = customCategoryInput.value.trim();
      if (!label) return {error: '새 분류 이름을 입력해 주세요.'};
      const slug = label.normalize('NFKC').toLocaleLowerCase('ko-KR').replace(/[^\p{L}\p{N}]+/gu, '-').replace(/^-|-$/g, '');
      if (!slug) return {error: '분류 이름에 글자나 숫자를 넣어 주세요.'};
      return {section: 'custom-' + slug, parent: 'custom', label, isCustom: true};
    }
    const option = categorySelect.selectedOptions[0];
    return {
      section: option.dataset.section || value.replace(/^section:/, ''),
      parent: option.dataset.parent || 'custom',
      label: option.dataset.label || option.textContent.trim(),
      isCustom: option.dataset.parent === 'custom'
    };
  };

  const safeReadDraft = () => {
    try { return localStorage.getItem(draftKey); } catch (_) { return null; }
  };
  const safeWriteDraft = () => {
    try {
      localStorage.setItem(draftKey, JSON.stringify({
        version: 2,
        title: titleInput.value,
        date: dateInput.value,
        tags: tagsInput.value,
        category: categorySelect.value,
        customCategory: customCategoryInput.value,
        body: body.value
      }));
      return true;
    } catch (_) { return false; }
  };
  const safeClearDraft = () => {
    try { localStorage.removeItem(draftKey); return true; } catch (_) { return false; }
  };

  const update = save => {
    const title = titleInput.value.trim() || autoTitle(body.value);
    const date = normalizeDate(dateInput.value);
    const tags = normalizeTags(tagsInput.value);
    const category = selectedCategory();
    previewTitle.textContent = title;
    previewTitle.hidden = !title;
    previewBody.innerHTML = body.value.trim()
      ? render(normalizeArticle(body.value, title))
      : '<p class="preview-empty">본문을 입력하면 여기에서 확인할 수 있습니다.</p>';
    const categoryLabel = category.error ? '분류 이름 입력 필요' : category.label || category.section;
    const dateLabel = date || '날짜 확인 필요';
    metaSummary.textContent = (title || '제목을 입력해 주세요') + ' · ' + dateLabel + ' · ' + (tags.length ? tags.join(', ') : '태그 없음') + ' · ' + categoryLabel;
    previewState.textContent = body.value.trim() ? '미리보기' : '본문 입력 대기';
    if (save) {
      status.textContent = '저장 중…';
      window.clearTimeout(update.saveTimer);
      update.saveTimer = window.setTimeout(() => {
        status.textContent = safeWriteDraft()
          ? '자동 저장됨 · ' + new Intl.DateTimeFormat('ko-KR', {hour: '2-digit', minute: '2-digit'}).format(new Date())
          : '브라우저 저장을 사용할 수 없습니다. 파일로 저장해 주세요.';
        status.className = 'status' + (status.textContent.startsWith('자동 저장됨') ? ' ok' : ' error');
      }, 250);
    }
  };

  const setCategoryFromFrontMatter = (section, label) => {
    const options = [...categorySelect.options];
    const match = options.find(option => option.dataset.section === String(section || ''));
    if (match) {
      categorySelect.value = match.value;
      customFields.hidden = true;
      customCategoryInput.value = '';
    } else if (section) {
      const option = document.createElement('option');
      option.value = 'section:' + section;
      option.dataset.section = section;
      option.dataset.parent = 'custom';
      option.dataset.label = label || section.replace(/^custom-/, '');
      option.textContent = option.dataset.label;
      categorySelect.insertBefore(option, categorySelect.querySelector('option[value="new"]'));
      categorySelect.value = option.value;
      customFields.hidden = true;
      customCategoryInput.value = '';
    } else {
      categorySelect.value = 'auto';
      customFields.hidden = true;
      customCategoryInput.value = '';
    }
  };

  const importFrontMatter = parsed => {
    const data = parsed.data || {};
    titleInput.value = String(data.title || autoTitle(parsed.body) || '');
    dateInput.value = data.date ? normalizeDate(data.date) : today();
    tagsInput.value = normalizeTags(data.tags).join(', ');
    setCategoryFromFrontMatter(data.section, data.section_label);
    body.value = parsed.body;
  };

  let updateTimer = 0;
  const scheduleUpdate = () => {
    window.clearTimeout(updateTimer);
    status.textContent = '수정 내용 저장 중…';
    status.className = 'status';
    updateTimer = window.setTimeout(() => update(true), 180);
  };

  const applyToolbar = action => {
    const start = body.selectionStart, end = body.selectionEnd;
    const selected = body.value.slice(start, end);
    const wrappers = {
      bold: ['**', '**'], heading: ['## ', ''], code: ['~~~\n', '\n~~~'], quote: ['> ', ''], list: ['- ', ''], link: ['[', '](https://)']
    };
    if (action === 'table') {
      const table = '| 항목 | 설명 |\n| --- | --- |\n| 항목 1 | 설명 입력 |\n| 항목 2 | 설명 입력 |';
      body.setRangeText(table, start, end, 'end');
    } else {
      const pair = wrappers[action];
      if (!pair) return;
      body.setRangeText(pair[0] + (selected || '내용') + pair[1], start, end, 'end');
    }
    body.focus();
    scheduleUpdate();
  };

  document.querySelectorAll('.editor-toolbar button').forEach(button => {
    button.addEventListener('click', () => applyToolbar(button.dataset.action));
  });

  body.addEventListener('input', () => {
    const parsed = readFrontMatter(body.value);
    if (parsed) {
      importFrontMatter(parsed);
    } else if (!titleInput.value.trim()) {
      const found = autoTitle(body.value);
      if (found) titleInput.value = found;
    }
    scheduleUpdate();
  });

  [titleInput, dateInput, tagsInput, customCategoryInput].forEach(input => input.addEventListener('input', scheduleUpdate));
  categorySelect.addEventListener('change', () => {
    customFields.hidden = categorySelect.value !== 'new';
    scheduleUpdate();
  });
  document.getElementById('add-category').addEventListener('click', () => {
    categorySelect.value = 'new';
    customFields.hidden = false;
    customCategoryInput.focus();
    scheduleUpdate();
  });

  document.getElementById('reset-post').addEventListener('click', () => {
    if ((body.value.trim() || titleInput.value.trim()) && !window.confirm('현재 초안을 지우고 새 글을 시작할까요?')) return;
    window.clearTimeout(updateTimer);
    window.clearTimeout(update.saveTimer);
    body.value = '';
    titleInput.value = '';
    dateInput.value = today();
    tagsInput.value = '';
    categorySelect.value = 'auto';
    customCategoryInput.value = '';
    customFields.hidden = true;
    const removed = safeClearDraft();
    update(false);
    status.textContent = removed ? '새 글을 시작합니다.' : '초안은 지웠지만 브라우저 저장 공간을 정리하지 못했습니다.';
    status.className = 'status' + (removed ? '' : ' error');
  });

  document.getElementById('download-post').addEventListener('click', () => {
    window.clearTimeout(updateTimer);
    window.clearTimeout(update.saveTimer);
    const title = titleInput.value.trim() || autoTitle(body.value);
    const date = normalizeDate(dateInput.value);
    const tags = normalizeTags(tagsInput.value);
    const category = selectedCategory();
    if (!title) { status.textContent = '제목을 입력해 주세요.'; status.className = 'status error'; titleInput.focus(); return; }
    if (!date) { status.textContent = '올바른 날짜를 선택해 주세요.'; status.className = 'status error'; dateInput.focus(); return; }
    if (!body.value.trim()) { status.textContent = '본문을 입력해 주세요.'; status.className = 'status error'; body.focus(); return; }
    if (category.error) { status.textContent = category.error; status.className = 'status error'; customCategoryInput.focus(); return; }

    const content = normalizeArticle(stripFrontMatter(body.value), title);
    const fields = [
      '---',
      'layout: post',
      'title: ' + yamlQuote(title),
      'date: ' + date + ' 00:00:00 +0900',
      'categories: [' + yamlQuote(category.parent === 'custom' ? '내 분류' : category.parent) + ']',
      'section: ' + yamlQuote(category.section)
    ];
    if (category.isCustom) fields.push('section_label: ' + yamlQuote(category.label));
    fields.push('tags: [' + (tags.length ? tags.map(yamlQuote).join(', ') : yamlQuote('Study')) + ']', '---', '');
    const fileContent = fields.join('\n') + content;
    const draftSaved = safeWriteDraft();
    const blob = new Blob([fileContent], {type: 'text/markdown;charset=utf-8'});
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    const filenameSlug = title.normalize('NFKC').toLocaleLowerCase('ko-KR').replace(/[^\p{L}\p{N}]+/gu, '-').replace(/^-|-$/g, '').slice(0, 90) || 'post';
    link.href = url;
    link.download = date + '-' + filenameSlug + '.md';
    link.click();
    window.setTimeout(() => URL.revokeObjectURL(url), 1000);
    status.textContent = draftSaved
      ? 'Markdown 파일을 저장하고 초안도 브라우저에 보관했습니다.'
      : 'Markdown 파일은 저장했지만 브라우저 초안은 저장하지 못했습니다.';
    status.className = 'status' + (draftSaved ? ' ok' : ' error');
  });

  let importedDraft = false;
  const storedDraft = safeReadDraft();
  if (storedDraft) {
    try {
      const saved = JSON.parse(storedDraft);
      if (saved && saved.version === 2) {
        titleInput.value = saved.title || '';
        dateInput.value = normalizeDate(saved.date) || today();
        tagsInput.value = saved.tags || '';
        categorySelect.value = saved.category || 'auto';
        customCategoryInput.value = saved.customCategory || '';
        customFields.hidden = categorySelect.value !== 'new';
        body.value = saved.body || '';
        importedDraft = true;
      } else {
        body.value = storedDraft;
        const parsed = readFrontMatter(body.value);
        if (parsed) importFrontMatter(parsed);
        else if (!titleInput.value) titleInput.value = autoTitle(body.value);
        importedDraft = true;
      }
    } catch (_) {
      body.value = storedDraft;
      const parsed = readFrontMatter(body.value);
      if (parsed) importFrontMatter(parsed);
      importedDraft = true;
    }
  } else {
    dateInput.value = today();
  }
  update(false);
  if (importedDraft) status.textContent = '이전에 작성하던 초안을 불러왔습니다.';
  window.addEventListener('pagehide', () => {
    window.clearTimeout(updateTimer);
    if (body.value.trim() || titleInput.value.trim()) safeWriteDraft();
  });
})();
</script>
